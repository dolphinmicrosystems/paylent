class Contact {
  final String id;
  String name;
  String email;
  bool isLoggedUser;
  final String avatarUrl;
  final bool isFavorite;

  Contact({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    this.isFavorite = false,
    this.isLoggedUser = false,
  });

  Contact copy() => Contact(
        id: id,
        name: name,
        email: email,
        avatarUrl: avatarUrl,
        isFavorite: isFavorite,
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
