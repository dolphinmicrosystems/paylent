import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart' as flutter_contacts;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/models/contact_info.dart';
import 'package:paylent/models/registered_user.dart';
import 'package:paylent/models/user.dart';
import 'package:paylent/services/device_contacts_service.dart';
import 'package:paylent/utils/phone_normalizer.dart';

final contactsProvider =
    StateNotifierProvider<ContactsNotifier, AsyncValue<List<Contact>>>(
  (final ref) => ContactsNotifier(),
);

class ContactsNotifier extends StateNotifier<AsyncValue<List<Contact>>> {
  ContactsNotifier() : super(const AsyncValue.loading()) {
    state = AsyncValue.data(_initialContacts);
  }

  static final _initialContacts = [
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

  List<Contact> get contacts => state.value ?? [];

  Contact? getByIdSafe(final String id) {
    final list = state.value;

    if (list == null || list.isEmpty) {
      debugPrint(
        'ContactsNotifier.getByIdSafe: '
        'Contacts not loaded yet. id=$id',
      );
      return null;
    }

    for (final c in list) {
      if (c.id == id) return c;
    }

    debugPrint(
      'ContactsNotifier.getByIdSafe: '
      'Contact not found. id=$id',
    );

    return null;
  }

  void update(final Contact updated) {
    state = AsyncValue.data([
      for (final c in contacts)
        if (c.id == updated.id) updated else c
    ]);
  }

  Future<void> loadFromDevice() async {
    state = const AsyncValue.loading();

    try {
      final rawContacts = await fetchDeviceContacts();

      final mapped = rawContacts.where((c) => c.phones.isNotEmpty).map((c) {
        final phone = normalizePhone(c.phones.first.number);

        return Contact(
          id: 'phone_$phone',
          name: c.displayName,
          email: '',
          avatarUrl: '',
          phoneNumber: phone,
          isRegistered: false,
        );
      }).toList();

      state = AsyncValue.data(mapped);
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void ensureCurrentUser(final AppUser user) {
    final exists = contacts.any((final c) => c.id == user.id);
    if (!exists) {
      state = AsyncValue.data([
        Contact(
          id: user.id,
          name: user.name,
          email: user.email,
          avatarUrl: user.avatarUrl,
          isLoggedUser: true,
          isRegistered: true,
        ),
        ...contacts,
      ]);
    }
  }

  String displayName({
    required final Contact contact,
    required final String currentUserId,
  }) =>
      contact.id == currentUserId ? 'You' : contact.name;

  void delete(final String id) {
    state = AsyncValue.data(contacts.where((final c) => c.id != id).toList());
  }

  final contactsProvider =
      StateNotifierProvider<ContactsNotifier, AsyncValue<List<Contact>>>(
    (final ref) => ContactsNotifier(),
  );

  void loadFromPhoneContacts(
      final List<flutter_contacts.Contact> phoneContacts) {
    state = AsyncValue.data([
      for (final p in phoneContacts)
        if (p.phones.isNotEmpty)
          Contact(
            id: 'phone_${normalizePhone(p.phones.first.number)}',
            name: p.displayName,
            phoneNumber: normalizePhone(p.phones.first.number),
            email: '',
            avatarUrl: '',
            isRegistered: false,
          ),
    ]);
  }

  void markRegisteredUsers(final List<RegisteredUser> users) {
    state = AsyncValue.data([
      for (final c in contacts)
        users.any((final u) => u.phoneNumber == c.phoneNumber)
            ? c.copyWith(
                id: users
                    .firstWhere((final u) => u.phoneNumber == c.phoneNumber)
                    .userId,
                isRegistered: true,
              )
            : c,
    ]);
  }
}
