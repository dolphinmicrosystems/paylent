import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/models/contact_info.dart';
import 'package:paylent/providers/contacts_notifier.dart';
import 'package:paylent/screens/contacts/contact_detail_screen.dart';
import 'package:paylent/screens/contacts/contact_search_bar.dart';
import 'package:paylent/screens/contacts/widgets/alphabet_section.dart';
import 'package:paylent/screens/contacts/widgets/contact_tile.dart';
import 'package:paylent/screens/contacts/widgets/contacts_tabs.dart';

class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({super.key});

  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> {
  int _selectedTab = 0; // 0 = All, 1 = Favorites
  String _searchQuery = '';

  List<Contact> get filteredContacts {
    final contactsAsync = ref.watch(contactsProvider);
    final allContacts = contactsAsync.value ?? const <Contact>[];
    return Contact.filter(
      allContacts: allContacts,
      searchQuery: _searchQuery,
      selectedTab: _selectedTab,
    );
  }

  Future<void> _openDetail(final String contactId) async {
    await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (final _) => ContactDetailScreen(contactId: contactId),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Contacts')),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {
                // Handle add contact action
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            ContactSearchBar(
              onChanged: (final value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
            ContactsTabs(
              selectedTab: _selectedTab,
              onTabChanged: (final tab) {
                setState(() {
                  _selectedTab = tab;
                });
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filteredContacts.isEmpty
                  ? const Center(child: Text('No contacts found'))
                  : Stack(
                      children: [
                        _buildContactList(),
                        // const AlphabetIndex(),
                      ],
                    ),
            ),
          ],
        ),
      );

  Widget _buildContactList() => Scrollbar(
      thumbVisibility: true,
      child: ListView(
        children: AlphabetSection.fromContacts(
          contacts: filteredContacts,
          itemBuilder: (contact) => ContactTile(
            contact: contact,
            onTap: () {
              _openDetail(contact.id);
            },
          ),
        ),
      ));
}
