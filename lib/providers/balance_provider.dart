import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/models/member_balance.dart';
import 'package:paylent/providers/contacts_notifier.dart';
import 'package:paylent/providers/transactions_provider.dart';

// A provider that calculates the net balance for everyone in a specific group
final groupBalancesProvider = Provider.family<List<MemberBalance>, String>((final ref, final groupId) {
  // 1. Get all transactions for this specific group
  final allTransactions = ref.watch(transactionsProvider);
  final groupTransactions = allTransactions.where((final tx) => tx.groupId == groupId).toList();
  
  // 2. We need the contacts provider to map IDs to real names/avatars
  final contactsNotifier = ref.read(notifierProvider.notifier);

  // 3. This map will hold the running total for each user ID
  // Key: Contact ID | Value: Net Balance
  final Map<String, double> calculatedBalances = {};

  for (final tx in groupTransactions) {
    // A. Credit the person who paid (their balance goes UP)
    calculatedBalances[tx.paidByContactId] = 
        (calculatedBalances[tx.paidByContactId] ?? 0) + tx.amount;

    // B. Debit the people who share the expense (their balance goes DOWN)
    // NOTE: You will need to adapt this part based on how your Transaction model 
    // stores the "splits" or "involved members". 
    // Assuming an equal split among a list of `involvedContactIds` for this example:
    
    /* UNCOMMENT AND ADAPT THIS TO YOUR ACTUAL TRANSACTION MODEL
    if (tx.involvedContactIds != null && tx.involvedContactIds.isNotEmpty) {
      final splitAmount = tx.amount / tx.involvedContactIds.length;
      
      for (final participantId in tx.involvedContactIds) {
        calculatedBalances[participantId] = 
            (calculatedBalances[participantId] ?? 0) - splitAmount;
      }
    }
    */
  }

  // 4. Convert the Map into our List<MemberBalance> model
  return calculatedBalances.entries.map((final entry) {
    final contactId = entry.key;
    final netBalance = entry.value;
    
    // Fetch the user's details using your existing contact methods
    final contact = contactsNotifier.getByIdSafe(contactId);

    return MemberBalance(
      id: contactId,
      name: contact?.name ?? 'Unknown User',
      avatarUrl: contact?.avatarUrl ?? '', 
      balance: netBalance,
    );
  })
  // Optional: Filter out people whose balance is exactly $0.00
  .where((final member) => member.balance.abs() > 0.01) 
  .toList();
});