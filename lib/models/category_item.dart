import 'package:flutter/material.dart';
import 'package:paylent/models/transaction_category.dart';

class CategoryItem {
  final TransactionCategory category;
  final String title;
  final IconData icon;
  final String section;
  final Color? iconColor;
  final Color? backgroundColor;

  const CategoryItem({
    required this.category,
    required this.title,
    required this.icon,
    required this.section,
    required this.iconColor,
    this.backgroundColor,
  });
}

List<CategoryItem> _allCategoryItems = [
  // ───── General ─────
  CategoryItem(
    category: TransactionCategory.general,
    title: 'General',
    icon: Icons.description,
    section: 'General',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),
  CategoryItem(
    category: TransactionCategory.adjustment,
    title: 'Adjustment',
    icon: Icons.tune,
    section: 'General',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),

  // ───── Entertainment ─────
  CategoryItem(
    category: TransactionCategory.games,
    title: 'Games',
    icon: Icons.sports_esports,
    section: 'Entertainment',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),
  CategoryItem(
    category: TransactionCategory.movies,
    title: 'Movies',
    icon: Icons.movie,
    section: 'Entertainment',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),
  CategoryItem(
    category: TransactionCategory.music,
    title: 'Music',
    icon: Icons.music_note,
    section: 'Entertainment',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),
  CategoryItem(
    category: TransactionCategory.concerts,
    title: 'Concerts',
    icon: Icons.queue_music,
    section: 'Entertainment',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),
  CategoryItem(
    category: TransactionCategory.sports,
    title: 'Sports',
    icon: Icons.sports_soccer,
    section: 'Entertainment',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),
  CategoryItem(
    category: TransactionCategory.streaming,
    title: 'Streaming',
    icon: Icons.tv,
    section: 'Entertainment',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),

  // ───── Food & Drink ─────
  CategoryItem(
    category: TransactionCategory.groceries,
    title: 'Groceries',
    icon: Icons.shopping_cart,
    section: 'Food & Drink',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),
  CategoryItem(
    category: TransactionCategory.dining,
    title: 'Dining Out',
    icon: Icons.restaurant,
    section: 'Food & Drink',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),
  CategoryItem(
    category: TransactionCategory.cafe,
    title: 'Cafe',
    icon: Icons.coffee,
    section: 'Food & Drink',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),
  CategoryItem(
    category: TransactionCategory.fastFood,
    title: 'Fast Food',
    icon: Icons.lunch_dining,
    section: 'Food & Drink',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),
  CategoryItem(
    category: TransactionCategory.liquor,
    title: 'Liquor',
    icon: Icons.wine_bar,
    section: 'Food & Drink',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),

  // ───── Transport ─────
  CategoryItem(
    category: TransactionCategory.fuel,
    title: 'Fuel',
    icon: Icons.local_gas_station,
    section: 'Transport',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),
  CategoryItem(
    category: TransactionCategory.taxi,
    title: 'Taxi / Ride share',
    icon: Icons.local_taxi,
    section: 'Transport',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),
  CategoryItem(
    category: TransactionCategory.publicTransport,
    title: 'Public Transport',
    icon: Icons.directions_bus,
    section: 'Transport',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),
  CategoryItem(
    category: TransactionCategory.parking,
    title: 'Parking',
    icon: Icons.local_parking,
    section: 'Transport',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),
  CategoryItem(
    category: TransactionCategory.vehicleMaintenance,
    title: 'Vehicle Maintenance',
    icon: Icons.build,
    section: 'Transport',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),

  // ───── Home ─────
  CategoryItem(
    category: TransactionCategory.rent,
    title: 'Rent',
    icon: Icons.home,
    section: 'Home',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),
  CategoryItem(
    category: TransactionCategory.utilities,
    title: 'Utilities',
    icon: Icons.electrical_services,
    section: 'Home',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),
  CategoryItem(
    category: TransactionCategory.internet,
    title: 'Internet',
    icon: Icons.wifi,
    section: 'Home',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),
  CategoryItem(
    category: TransactionCategory.mobile,
    title: 'Mobile',
    icon: Icons.phone_android,
    section: 'Home',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),
  CategoryItem(
    category: TransactionCategory.repairs,
    title: 'Repairs',
    icon: Icons.handyman,
    section: 'Home',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),

  // ───── Health ─────
  CategoryItem(
    category: TransactionCategory.medical,
    title: 'Medical',
    icon: Icons.local_hospital,
    section: 'Health',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),
  CategoryItem(
    category: TransactionCategory.pharmacy,
    title: 'Pharmacy',
    icon: Icons.medication,
    section: 'Health',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),
  CategoryItem(
    category: TransactionCategory.fitness,
    title: 'Fitness',
    icon: Icons.fitness_center,
    section: 'Health',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),
  CategoryItem(
    category: TransactionCategory.insurance,
    title: 'Insurance',
    icon: Icons.health_and_safety,
    section: 'Health',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),

  // ───── Travel ─────
  CategoryItem(
    category: TransactionCategory.flights,
    title: 'Flights',
    icon: Icons.flight,
    section: 'Travel',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),
  CategoryItem(
    category: TransactionCategory.hotels,
    title: 'Hotels',
    icon: Icons.hotel,
    section: 'Travel',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),
  CategoryItem(
    category: TransactionCategory.activities,
    title: 'Activities',
    icon: Icons.map,
    section: 'Travel',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),

  // ───── Shopping ─────
  CategoryItem(
    category: TransactionCategory.clothing,
    title: 'Clothing',
    icon: Icons.checkroom,
    section: 'Shopping',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),
  CategoryItem(
    category: TransactionCategory.electronics,
    title: 'Electronics',
    icon: Icons.devices,
    section: 'Shopping',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),
  CategoryItem(
    category: TransactionCategory.gifts,
    title: 'Gifts',
    icon: Icons.card_giftcard,
    section: 'Shopping',
    iconColor: Colors.blueGrey.shade100,
    backgroundColor: Colors.blue.shade900,
  ),
];

CategoryItem getCategoryItem(final TransactionCategory category) =>
    _allCategoryItems.firstWhere(
      (final item) => item.category == category,
      orElse: () => _allCategoryItems.first,
    );

List<CategoryItem> getCategoryItemByTitle(final String title) =>
    _allCategoryItems
        .where((final item) =>
            item.title.toLowerCase().contains(title.toLowerCase()))
        .toList();
