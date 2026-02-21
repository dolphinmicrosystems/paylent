import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/providers/contacts_notifier.dart';
import 'package:paylent/providers/groups_provider.dart';
import 'package:paylent/screens/contacts/contact_detail_screen.dart';
import 'package:paylent/screens/contacts/widgets/contact_avatar.dart';

class GroupMembersSheet extends ConsumerStatefulWidget {
  final String groupId;
  const GroupMembersSheet({
    required this.groupId,
    super.key,
  });

  @override
  ConsumerState<GroupMembersSheet> createState() => _GroupMembersSheetState();
}

class _GroupMembersSheetState extends ConsumerState<GroupMembersSheet> {
  @override
  void initState() {
    super.initState();
    // Future.microtask(() {
    //   ref.read(notifierProvider.notifier).loadFromDevice();
    // });
  }

  @override
  Widget build(final BuildContext context) {
    final contactsAsync = ref.watch(notifierProvider);
    final group =
        ref.watch(groupsProvider).firstWhere((final g) => g.id == widget.groupId);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (final _, final controller) => SafeArea(
        top: false,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1C1C1E),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: contactsAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (final _, final __) => const Center(
              child: Text('Error loading members'),
            ),
            data: (final contacts) {
              final members = contacts
                  .where(
                      (final c) => group.participantIds.contains(c.id))
                  .toList();

              return Column(
                children: [
                  const SizedBox(height: 12),

                  // Drag handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade600,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Group Members',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: ListView.separated(
                      controller: controller,
                      itemCount: members.length,
                      separatorBuilder: (final _, final __) =>
                          Divider(color: Colors.grey.shade800, height: 1),
                      itemBuilder: (final _, final index) {
                        final contact = members[index];

                        return ListTile(
                          leading: ContactAvatar(contact: contact),
                          title: Text(
                            contact.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (contact.email.isNotEmpty)
                                Text(
                                  contact.email,
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.white60),
                                ),
                              if (contact.phoneNumber != null &&
                                  contact.phoneNumber!.isNotEmpty)
                                Text(
                                  contact.phoneNumber!,
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.white38),
                                ),
                            ],
                          ),
                          isThreeLine: contact.email.isNotEmpty &&
                              contact.phoneNumber != null &&
                              contact.phoneNumber!.isNotEmpty,
                          trailing: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () async {
                                await Navigator.push<String>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (final _) => ContactDetailScreen(
                                        contactId: contact.id,
                                        groupId: group.id),
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.chevron_right,
                                color: Colors.white38,
                                size: 22,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
