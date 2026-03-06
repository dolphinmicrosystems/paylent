import 'package:flutter/material.dart';
import 'package:paylent/models/member_balance.dart';
import 'package:paylent/screens/contacts/widgets/contact_avatar.dart';

class MemberDetailsScreen extends StatelessWidget {
  final MemberBalance member;

  const MemberDetailsScreen({required this.member, super.key});

  @override
  Widget build(final BuildContext context) {
    final isPositive = member.balance >= 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(member.contact.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // --- 1. Top Summary Header ---
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
            child: Column(
              children: [
               ContactAvatar(contact: member.contact),
                const SizedBox(height: 16),
                Text(
                  isPositive ? 'Total owed to you' : 'Total you owe',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  '${isPositive ? '+' : '-'}\$${member.balance.abs().toStringAsFixed(2)}',
                  style: TextStyle(
                    color: isPositive ? Colors.greenAccent.shade400 : Colors.redAccent.shade400,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Optional: A quick action button (e.g., "Settle Up")
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement Settle Up logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPositive ? Colors.greenAccent.shade400 : Colors.blueAccent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: Text(isPositive ? 'Send Reminder' : 'Settle Up'),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white24, height: 1),

          // --- 2. Transaction History Title ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Transaction History',
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // --- 3. Mock Transaction List ---
          Expanded(
            child: ListView.builder(
              itemCount: 8, // Mock count
              itemBuilder: (final context, final index) {
                // Mock logic to alternate who paid
                final paidByMe = index % 2 == 0; 
                
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.receipt_long,
                      color: Colors.blue.shade300,
                    ),
                  ),
                  title: const Text(
                    'Dinner at Restaurant',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Feb ${20 - index}, 2026', 
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        paidByMe ? 'You paid \$100' : '${member.contact.name.split(' ')[0]} paid \$50',
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                      ),
                      Text(
                        paidByMe ? 'Lent \$50.00' : 'Borrowed \$25.00',
                        style: TextStyle(
                          color: paidByMe ? Colors.greenAccent.shade400 : Colors.redAccent.shade400,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}