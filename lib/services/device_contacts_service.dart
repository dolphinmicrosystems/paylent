import 'package:flutter/foundation.dart'; // For debugPrint
import 'package:flutter_contacts/flutter_contacts.dart';

Future<List<Contact>> fetchDeviceContacts() async {
  // FIX: Just use requestPermission(). 
  // It checks status internally and returns true immediately if already granted.
  final granted = await FlutterContacts.requestPermission(readonly: true);

  if (!granted) {
    debugPrint('Contacts permission denied');
    return [];
  }

  // If we get here, we have permission
  try {
    final contacts = await FlutterContacts.getContacts(
      withProperties: true,
    );

    debugPrint('Fetched contacts: ${contacts.length}');
    return contacts;
    
  } on Exception catch(e) {
    debugPrint('Error fetching contacts: $e');
    return [];
  }
}