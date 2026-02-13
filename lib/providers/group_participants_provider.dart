import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/models/contact_info.dart';
import 'package:paylent/providers/contacts_notifier.dart';
import 'package:paylent/providers/groups_provider.dart';

final groupParticipantsProvider =
    Provider.family<List<Contact>, String>((final ref, final groupId) {
  final group =
      ref.watch(groupsProvider).firstWhere((final g) => g.id == groupId);

  final contactsNotifier = ref.watch(contactsProvider.notifier);

  return contactsNotifier.contacts
      .where((final c) => group.participantIds.contains(c.id))
      .toList();
});
