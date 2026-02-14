import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/models/contact_info.dart';
import 'package:paylent/providers/contacts_notifier.dart';
import 'package:paylent/providers/selected_participants_provider.dart';
import 'package:paylent/screens/contacts/widgets/contact_avatar.dart';

class SelectedParticipantsRow extends ConsumerWidget {
  final String groupId;
  const SelectedParticipantsRow({required this.groupId, super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final selectedIds = ref.watch(selectedParticipantsProvider(groupId));
    final contactsAsync = ref.watch(notifierProvider);

    final selectedContacts = contactsAsync.maybeWhen(
      data: (final allContacts) =>
          allContacts.where((final c) => selectedIds.contains(c.id)).toList(),
      orElse: () => <Contact>[],
    );

    if (selectedContacts.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 72,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: selectedContacts.length,
        separatorBuilder: (final _, final __) => const SizedBox(width: 12),
        itemBuilder: (final _, final index) {
          final contact = selectedContacts[index];

          return Stack(
            clipBehavior: Clip.none,
            children: [
              ContactAvatar(contact: contact, radius: 28),
              Positioned(
                top: -4,
                right: -4,
                child: GestureDetector(
                  onTap: () {
                    ref
                        .read(selectedParticipantsProvider(groupId).notifier)
                        .toggle(contact.id);
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.close,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
