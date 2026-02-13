import 'package:paylent/models/registered_user.dart';

Future<List<RegisteredUser>> lookupRegisteredUsers(
  final List<String> phoneNumbers,
) async {
  // 🔧 Replace with real API later
  await Future.delayed(const Duration(seconds: 1));

  return [
    const RegisteredUser(
      userId: 'me_001',
      phoneNumber: '+6421123456',
      name: 'Alexia Hershey',
      avatarUrl: null,
    ),
  ];
}
