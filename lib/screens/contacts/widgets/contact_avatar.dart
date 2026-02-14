import 'package:flutter/material.dart';
import 'package:paylent/models/contact_info.dart';

class ContactAvatar extends StatelessWidget {
  const ContactAvatar({
    required this.contact, super.key,
    this.radius = 20,
  });

  final Contact contact;
  final double radius;

  @override
  Widget build(final BuildContext context) => CircleAvatar(
      radius: radius,
      backgroundImage: (contact.avatarUrl.isNotEmpty)
          ? NetworkImage(contact.avatarUrl)
          : null,
      backgroundColor: (contact.avatarUrl.isNotEmpty)
          ? Colors.transparent
          : Colors.blue.shade100,
      child: (contact.avatarUrl.isEmpty)
          ? Text(
              contact.name.isNotEmpty
                  ? contact.firstLetter.toUpperCase()
                  : '?',
              style: const TextStyle(
                color: Color.fromARGB(255, 44, 59, 74),
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
}
