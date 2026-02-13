import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/models/contact_info.dart';
import 'package:paylent/providers/contacts_notifier.dart';
import 'package:paylent/providers/groups_provider.dart';

class PaidBySelectionScreen extends ConsumerWidget {
  final String selectedValue; // contactId
  final String groupId;

  const PaidBySelectionScreen({
    required this.selectedValue,
    required this.groupId,
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    // 1️⃣ Get group
    final group = ref.watch(groupsProvider).firstWhere(
          (final g) => g.id == groupId,
        );

    // 2️⃣ Get contacts
    final contactsNotifier = ref.watch(contactsProvider.notifier);

    // 3️⃣ Filter group participants
    final List<Contact> participants = contactsNotifier.contacts
        .where((final c) => group.participantIds.contains(c.id))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Paid by')),
      body: participants.isEmpty
          ? const Center(child: Text('No participants found'))
          : ListView.builder(
              itemCount: participants.length,
              itemBuilder: (final context, final index) {
                final contact = participants[index];
                final isSelected = contact.id == selectedValue;

                return ListTile(
                  leading: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: (contact.avatarUrl.isNotEmpty)
                        ? NetworkImage(contact.avatarUrl)
                        : null,
                    child: (contact.avatarUrl.isEmpty)
                        ? Text(
                            contact.name.isNotEmpty
                                ? contact.name[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          )
                        : null,
                  ),
                  title: Text(
                    contact.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    Navigator.pop(context, contact.id);
                  },
                );
              },
            ),
    );
  }
}
