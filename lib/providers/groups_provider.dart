import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/models/group_category.dart';
import 'package:paylent/models/group_model.dart';

final groupsProvider = StateNotifierProvider<GroupsNotifier, List<Group>>(
  (final ref) => GroupsNotifier(),
);

class GroupsNotifier extends StateNotifier<List<Group>> {
  GroupsNotifier() : super(_initialGroups);

  static final _initialGroups = <Group>[
    const Group(
      id: 'g1',
      name: 'Roommates',
      category: GroupCategory.family,
      participantIds: ['me_001', '1', '2', '3'],
      transactionIds: ['t1', 't2'],
    ),
    const Group(
      id: 'g2',
      name: 'Trip to Goa',
      category: GroupCategory.trip,
      participantIds: ['me_001', '1', '3'],
      transactionIds: ['t3', 't4'],
    ),
  ];

  Group getById(final String id) => state.firstWhere((final g) => g.id == id);

  void addParticipant(final String groupId, final String contactId) {
    state = [
      for (final g in state)
        if (g.id == groupId)
          Group(
            id: g.id,
            name: g.name,
            participantIds: {...g.participantIds, contactId}.toList(),
            transactionIds: g.transactionIds,
          )
        else
          g,
    ];
  }

  void addGroup({
    required final String id,
    required final String title,
    required final String description,
    required final GroupCategory category,
    required final String imagePath,
    required final List<String> participantIds,
  }) {
    state = [
      ...state,
      Group(
        id: id,
        name: title,
        description: description,
        category: category,
        imagePath: imagePath,
        participantIds: participantIds,
        transactionIds: const [],
      ),
    ];
  }

  void setParticipants(
    final String groupId,
    final List<String> participantIds,
  ) {
    state = [
      for (final g in state)
        if (g.id == groupId)
          Group(
            id: g.id,
            name: g.name,
            description: g.description,
            category: g.category,
            imagePath: g.imagePath,
            participantIds: participantIds,
            transactionIds: g.transactionIds,
          )
        else
          g,
    ];
  }

  void removeParticipant(final String groupId, final String contactId) {
    state = [
      for (final g in state)
        if (g.id == groupId)
          Group(
            id: g.id,
            name: g.name,
            description: g.description,
            category: g.category,
            imagePath: g.imagePath,
            participantIds:
                g.participantIds.where((final id) => id != contactId).toList(),
            transactionIds: g.transactionIds,
          )
        else
          g,
    ];
  }
}
