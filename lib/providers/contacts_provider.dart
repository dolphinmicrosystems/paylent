import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/models/contact_info.dart';
import 'package:paylent/models/user.dart';

final contactsProvider = StateNotifierProvider<ContactsNotifier, List<Contact>>(
  (final ref) => ContactsNotifier(),
);

class ContactsNotifier extends StateNotifier<List<Contact>> {
  ContactsNotifier() : super(_initialContacts);
  static final _initialContacts = <Contact>[
    Contact(
      id: '1',
      name: 'Alexia Hershey',
      email: 'alexia.hershey@gmail.com',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      isFavorite: true,
    ),
    Contact(
      id: '2',
      name: 'Alfonzo Schuessler',
      email: 'alfonzo.schuessler@gmail.com',
      avatarUrl: 'https://i.pravatar.cc/150?img=2',
    ),
    Contact(
      id: '3',
      name: 'Augustina Midgett',
      email: 'augustina.midgett@gmail.com',
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
    ),
    Contact(
      id: '4',
      name: 'Charlotte Hanlin',
      email: 'charlotte.hanlin@gmail.com',
      avatarUrl: 'https://i.pravatar.cc/150?img=4',
      isFavorite: true,
    ),
    Contact(
      id: '5',
      name: 'Florencio Dorrance',
      email: 'florencio.dorrance@gmail.com',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      isFavorite: true,
    ),
  ];

  Contact getById(final String id) => state.firstWhere((final c) => c.id == id);

  void update(final Contact updated) {
    state = [
      for (final c in state)
        if (c.id == updated.id) updated else c
    ];
  }

  void ensureCurrentUser(final AppUser user) {
  final exists = state.any((final c) => c.id == user.id);
  if (!exists) {
    state = [
      Contact(
        id: user.id, 
        name: user.name,
        email: user.email,
        avatarUrl: user.avatarUrl,
      ),
      ...state,
    ];
  }
}

  String displayName({
    required final Contact contact,
    required final String currentUserId,
  }) =>
      contact.id == currentUserId ? 'You' : contact.name;

  void delete(final String id) {
    state = state.where((final c) => c.id != id).toList();
  }

  final contactsProvider =
      StateNotifierProvider<ContactsNotifier, List<Contact>>(
    (final ref) => ContactsNotifier(),
  );
}
