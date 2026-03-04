class MemberBalance {
  final String id;
  final String name;
  final String avatarUrl;
  final double balance; // Positive = they are owed, Negative = they owe

  MemberBalance({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.balance,
  });
}