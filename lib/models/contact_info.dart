class Contact {
  final String id;
  final String name;
  final String email;
  final bool isLoggedUser;
  final String avatarUrl;
  final bool isFavorite;
  final String? phoneNumber;
  final bool isRegistered;
  Contact({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    this.isFavorite = false,
    this.isLoggedUser = false,
    this.phoneNumber,
    this.isRegistered = false,
  });

  Contact copy() => Contact(
        id: id,
        name: name,
        email: email,
        avatarUrl: avatarUrl,
        isFavorite: isFavorite,
      );

  Contact copyWith({
    final String? id,
    final String? name,
    final String? email,
    final String? avatarUrl,
    final bool? isFavorite,
    final bool? isLoggedUser,
    final String? phoneNumber,
    final bool? isRegistered,
  }) =>
      Contact(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        isFavorite: isFavorite ?? this.isFavorite,
        isLoggedUser: isLoggedUser ?? this.isLoggedUser,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        isRegistered: isRegistered ?? this.isRegistered,
      );

  String get firstLetter => name[0].toUpperCase();

  static List<Contact> filter({
    required final List<Contact> allContacts,
    required final String searchQuery,
    required final int selectedTab,
  }) {
    final query = searchQuery.toLowerCase();

    return allContacts.where((final contact) {
      final matchesSearch = contact.name.toLowerCase().contains(query) ||
          contact.email.toLowerCase().contains(query);

      final matchesTab = selectedTab == 0 || contact.isFavorite;

      return matchesSearch && matchesTab;
    }).toList();
  }
}
