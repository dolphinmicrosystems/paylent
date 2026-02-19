import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/models/contact_info.dart';
import 'package:paylent/providers/selected_participants_provider.dart';
import 'package:paylent/screens/contacts/contact_detail_screen.dart';
import 'package:paylent/screens/contacts/widgets/contact_avatar.dart';

class  ParticipantContactTile extends ConsumerWidget {
  final Contact contact;
  final String groupId;

  const ParticipantContactTile(
      {required this.contact, required this.groupId, super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final selectedIds = ref.watch(selectedParticipantsProvider(groupId));
    final isSelected = selectedIds.contains(contact.id);

    return InkWell(
      onTap: () {
        ref
            .read(selectedParticipantsProvider(groupId).notifier)
            .toggle(contact.id);
      },
      onDoubleTap: () async {
        await Navigator.push<String>(
          context,
          MaterialPageRoute(
            builder: (final _) => ContactDetailScreen(contactId: contact.id),
          ),
        );
      },
      child: ListTile(
        leading: ContactAvatar(contact: contact),
        title: Text(contact.name),
        subtitle: Text(contact.email),
        trailing: SizedBox(
          width: 50,
          child: Row(
            children: [
              if (contact.isFavorite)
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 20,
                ),
              if (isSelected) ...[
                const SizedBox(width: 6),
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 22,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

