import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/models/contact_info.dart';
import 'package:paylent/models/group_draft_provider.dart';
import 'package:paylent/models/participants_screen_mode.dart';
import 'package:paylent/providers/contacts_notifier.dart';
import 'package:paylent/providers/groups_provider.dart';
import 'package:paylent/providers/selected_participants_provider.dart';
import 'package:paylent/screens/contacts/contact_search_bar.dart';
import 'package:paylent/screens/contacts/widgets/alphabet_section.dart';
import 'package:paylent/screens/contacts/widgets/contacts_tabs.dart';
import 'package:paylent/screens/contacts/widgets/participant_contact_tile.dart';
import 'package:paylent/screens/contacts/widgets/selected_participants_row.dart';

class ParticipantsScreen extends ConsumerStatefulWidget {
  final ParticipantsScreenMode mode;
  final String? groupId; // only for edit mode

  const ParticipantsScreen({
    required this.mode,
    this.groupId,
    super.key,
  });

  @override
  ConsumerState<ParticipantsScreen> createState() => _ParticipantsScreenState();
}

class _ParticipantsScreenState extends ConsumerState<ParticipantsScreen> {
  int _selectedTab = 0;
  String _searchQuery = '';
  late final ScrollController _listController;
  late final String _selectionKey;

  @override
  void initState() {
    super.initState();
    _listController = ScrollController();
    _selectionKey = widget.mode == ParticipantsScreenMode.createGroup
        ? 'draft_${DateTime.now().millisecondsSinceEpoch}'
        : widget.groupId!;

    Future.microtask(() {
      ref.read(notifierProvider.notifier).loadFromDevice();
    });
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  Map<String, int> buildLetterIndexMap(final List<Contact> contacts) {
    final map = <String, int>{};

    for (int i = 0; i < contacts.length; i++) {
      final letter = contacts[i].name[0].toUpperCase();
      map.putIfAbsent(letter, () => i);
    }

    return map;
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Add Members'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            ContactSearchBar(
              onChanged: (final value) {
                setState(() => _searchQuery = value);
              },
            ),
            SelectedParticipantsRow(
              groupId: _selectionKey,
            ),
            const SizedBox(height: 8),
            ContactsTabs(
              selectedTab: _selectedTab,
              onTabChanged: (final tab) {
                setState(() => _selectedTab = tab);
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ref.watch(notifierProvider).when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (final err, final _) => const Center(
                      child: Text('Error loading contacts'),
                    ),
                    data: (final allContacts) {
                      final filtered = Contact.filter(
                        allContacts: allContacts,
                        searchQuery: _searchQuery,
                        selectedTab: _selectedTab,
                      );

                      if (filtered.isEmpty) {
                        return const Center(child: Text('No contacts found'));
                      }

                      return ListView(
                        children: AlphabetSection.fromContacts(
                          contacts: filtered,
                          itemBuilder: (final contact) =>
                              ParticipantContactTile(
                            contact: contact,
                            groupId: _selectionKey,
                          ),
                        ),
                      );
                    },
                  ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ref
                          .read(selectedParticipantsProvider(_selectionKey)
                              .notifier)
                          .clear();
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final selectedIds = ref
                          .read(selectedParticipantsProvider(_selectionKey))
                          .toList();

                      if (widget.mode == ParticipantsScreenMode.createGroup) {
                        // ✅ CREATE FLOW (uses draft)
                        final draft = ref.read(groupDraftProvider);
                        if (draft == null) return;

                        ref.read(groupsProvider.notifier).addGroup(
                              id: _selectionKey,
                              title: draft.name,
                              description: draft.description,
                              category: draft.category,
                              imagePath: draft.imagePath,
                              participantIds: selectedIds,
                            );

                        ref.read(groupsProvider.notifier).setParticipants(
                              _selectionKey,
                              selectedIds,
                            );
                        ref.read(groupDraftProvider.notifier).clear();
                        Navigator.popUntil(
                            context, (final route) => route.isFirst);
                      } else {
                        // ✅ EDIT FLOW (updates existing group)
                        if (widget.groupId == null) return;

                        ref.read(groupsProvider.notifier).setParticipants(
                              _selectionKey,
                              selectedIds,
                            );

                        Navigator.pop(context, true);
                      }
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
