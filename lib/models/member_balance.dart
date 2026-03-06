import 'package:paylent/models/contact_info.dart';

class MemberBalance {
  final String id;
  final Contact contact;
  final double balance; // Positive = they are owed, Negative = they owe

  MemberBalance({
    required this.contact,
    required this.id,
    required this.balance,
  });
}
