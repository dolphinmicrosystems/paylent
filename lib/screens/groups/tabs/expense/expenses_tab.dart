import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:paylent/app_nav.dart';
import 'package:paylent/models/transaction_model.dart';
import 'package:paylent/providers/contacts_notifier.dart';
import 'package:paylent/providers/transactions_provider.dart';
import 'package:paylent/screens/groups/tabs/expense/add_expense_screen.dart';
import 'package:paylent/utils/contact_display.dart';

class ExpensesTab extends ConsumerWidget {
  final List<Transaction> transactions;

  const ExpensesTab({
    required this.transactions,
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    if (transactions.isEmpty) {
      return const Center(
        child: Text(
          'No expenses yet',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    /// 1️⃣ Sort newest first
    final sorted = [...transactions]
      ..sort((final a, final b) => b.date.compareTo(a.date));

    /// 2️⃣ Group by month
    final Map<String, List<Transaction>> grouped = {};
    for (final tx in sorted) {
      final key = DateFormat('MMMM yyyy').format(tx.date);
      grouped.putIfAbsent(key, () => []).add(tx);
    }

    /// 3️⃣ Sort months (latest first)
    final months = grouped.keys.toList()
      ..sort((final a, final b) => DateFormat('MMMM yyyy')
          .parse(b)
          .compareTo(DateFormat('MMMM yyyy').parse(a)));

    /// 4️⃣ Flatten list
    final List<dynamic> flatList = [];
    for (final month in months) {
      flatList.add(month);
      flatList.addAll(grouped[month]!);
    }

    return SafeArea(
      top: false,
      bottom: false,
      child: CustomScrollView(
        key: const PageStorageKey<String>('expenses'),
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (final context, final i) {
                  final item = flatList[i];

                  /// Month header
                  if (item is String) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 4),
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                    );
                  }

                  /// Transaction row
                  final tx = item as Transaction;
                  final isFirstInGroup = i > 0 && flatList[i - 1] is String;

                  final contact = ref
                      .read(contactsProvider.notifier)
                      .getByIdSafe(tx.paidByContactId);

                  return Column(
                    children: [
                      if (!isFirstInGroup)
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color.fromARGB(59, 46, 46, 46),
                        ),
                      ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.orange,
                          child: Icon(Icons.receipt, color: Colors.white),
                        ),
                        title: Text(tx.title),
                        subtitle: Text('Paid by ${displayName(contact: contact, currentUserId: '')}'),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${tx.currency} ${tx.amount.toStringAsFixed(2)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatDate(tx.date),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        onTap: () async {
                          final result = await AppNav.push(
                              context,
                              AddExpenseScreen(
                                groupId: tx.groupId,
                                isEdit: true,
                                transaction: tx,
                              ));

                          /// All mutations go through provider
                          if (result == 'deleted') {
                            ref
                                .read(transactionsProvider.notifier)
                                .remove(tx.id);
                          }
                        },
                      ),
                    ],
                  );
                },
                childCount: flatList.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ---------- helpers ----------

  static String _formatDate(final DateTime date) =>
      '${DateFormat('MMM').format(date)} ${date.day}';
}
