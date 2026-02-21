import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/models/contact_info.dart';
import 'package:paylent/models/user.dart';
import 'package:paylent/services/device_contacts_service.dart';
import 'package:paylent/services/user_lookup_service.dart';
import 'package:paylent/utils/phone_normalizer.dart';

final notifierProvider =
    StateNotifierProvider<ContactsNotifier, AsyncValue<List<Contact>>>(
  (final ref) => ContactsNotifier(),
);

class ContactsNotifier extends StateNotifier<AsyncValue<List<Contact>>> {
  ContactsNotifier() : super(const AsyncValue.loading()) {
    //state = AsyncValue.data(_initialContacts);
  }

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
      // 1️⃣ Fetch raw device contacts
      final rawContacts = await fetchDeviceContacts();

      // 2️⃣ Map device contacts → app Contact model
      final futures = rawContacts
          .where((final c) => c.phones.isNotEmpty)
          .map((final c) async {
        final phone = normalizePhone(c.phones.first.number);
        final formatted = await formatPhoneForDisplay(phone);
        return Contact(
          id: 'phone_$phone', // temporary id
          name: c.displayName,
          email: '',
          avatarUrl: '',
          phoneNumber: formatted,
        );
      }).toList();

      final deviceContacts = await Future.wait(futures);

      if (deviceContacts.isEmpty) {
        state = const AsyncValue.data([]);
        return;
      }

      // 3️⃣ Lookup registered users
      final registeredUsers = await lookupRegisteredUsers(
        deviceContacts.map((final c) => c.phoneNumber!).toList(),
      );

      // 4️⃣ Convert registered users to Map for O(1) lookup
      final registeredMap = {
        for (final user in registeredUsers) user.phoneNumber: user,
      };

      // 5️⃣ Merge device contacts with registered users
      final mergedContacts = deviceContacts.map((final contact) {
        final match = registeredMap[contact.phoneNumber];

        if (match != null) {
          return contact.copyWith(
            id: match.userId, // replace temp id
            name: match.name, // optional: use backend name
            avatarUrl: match.avatarUrl ?? '',
            isRegistered: true,
          );
        }

        return contact;
      }).toList();

      // 6️⃣ Update state
      state = AsyncValue.data(mergedContacts);
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
}
