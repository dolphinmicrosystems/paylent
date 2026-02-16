import 'package:paylent/models/registered_user.dart';

Future<List<RegisteredUser>> lookupRegisteredUsers(
  final List<String> phoneNumbers,
) async {
  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 500));

  // 🔹 Mock database of registered users
  const mockRegisteredUsers = [
    RegisteredUser(
      userId: '1',
      phoneNumber: '6421123456',
      name: 'Alexia Hershey',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
    ),
    RegisteredUser(
      userId: '2',
      phoneNumber: '6421765432',
      name: 'Alfonzo Schuessler',
      avatarUrl: 'https://i.pravatar.cc/150?img=2',
    ),
    RegisteredUser(
      userId: '3',
      phoneNumber: '6421987654',
      name: 'Augustina Midgett',
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
    ),
    RegisteredUser(
      userId: '4',
      phoneNumber: '64215551234',
      name: 'Charlotte Hanlin',
      avatarUrl: 'https://i.pravatar.cc/150?img=4',
    ),
    RegisteredUser(
      userId: '5',
      phoneNumber: '64219998888',
      name: 'Florencio Dorrance',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
    ),
  ];

  // 🔹 Convert phoneNumbers to a Set for fast lookup (O(1))
  final phoneSet = phoneNumbers.toSet();

  // 🔹 Return only matched users
  return mockRegisteredUsers
      .where((final user) => phoneSet.contains(user.phoneNumber))
      .toList();
}
