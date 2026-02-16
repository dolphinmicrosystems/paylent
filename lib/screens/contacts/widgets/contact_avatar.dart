import 'package:flutter/material.dart';
import 'package:paylent/models/contact_info.dart';

class ContactAvatar extends StatelessWidget {
  const ContactAvatar({
    required this.contact,
    super.key,
    this.radius = 20,
  });

  final Contact contact;
  final double radius;

  @override
  Widget build(final BuildContext context) => Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
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
          ),

          // 🔴 Show pending icon if NOT registered
          if (!contact.isRegistered)
            Positioned(
              bottom: -radius * 0.1,
              right: -radius * 0.1,
              child: Container(
                width: radius * 0.9,
                height: radius * 0.9,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  Icons.access_time,
                  size: radius * 0.45,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      );
}
