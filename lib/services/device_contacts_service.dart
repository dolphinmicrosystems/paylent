import 'package:flutter_contacts/flutter_contacts.dart';

Future<List<Contact>> fetchDeviceContacts() async {
  if (!await FlutterContacts.requestPermission()) {
    return [];
  }

  return FlutterContacts.getContacts(
    withProperties: true,
  );
}
