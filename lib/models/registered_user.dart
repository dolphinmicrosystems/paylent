class RegisteredUser {
  final String userId;
  final String phoneNumber;
  final String name;
  final String? avatarUrl;

  const RegisteredUser({
    required this.userId,
    required this.phoneNumber,
    required this.name,
    this.avatarUrl,
  });

  factory RegisteredUser.fromJson(final Map<String, dynamic> json) => RegisteredUser(
      userId: json['userId'],
      phoneNumber: json['phone'],
      name: json['name'],
      avatarUrl: json['avatarUrl'],
    );
}
