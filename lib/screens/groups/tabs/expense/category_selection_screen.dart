import 'package:flutter/material.dart';
import 'package:paylent/models/category_item.dart';
import 'package:paylent/models/transaction_category.dart';

class CategorySelectionScreen extends StatefulWidget {
  final TransactionCategory selectedCategory;

  const CategorySelectionScreen({
    required this.selectedCategory,
    super.key,
  });

  @override
  State<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  late TransactionCategory _current;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _current = widget.selectedCategory;
  }

  @override
  Widget build(final BuildContext context) {
    // Filter by search
    final filteredItems = getCategoryItemByTitle(_searchQuery);

    // Group by section
    final Map<String, List<CategoryItem>> grouped = {};
    for (final item in filteredItems) {
      grouped.putIfAbsent(item.section, () => []).add(item);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Category'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // 🔍 Search
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search category',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (final value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),

          // 📂 Category list
          Expanded(
            child: ListView(
              children: grouped.entries.map((final entry) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section header
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    // Category items
                    ...entry.value.map((final item) {
                      final isSelected =
                          item.category == _current;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: item.backgroundColor,
                          child: Icon(
                            item.icon,
                            color: item.iconColor,
                          ),
                        ),
                        title: Text(item.title),
                        trailing: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.green,
                              )
                            : null,
                        onTap: () {
                          setState(() {
                            _current = item.category;
                          });
                        },
                      );
                    }),
                  ],
                )).toList(),
            ),
          ),

          // ✅ Bottom buttons
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, _current);
                      },
                      child: const Text('OK'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
