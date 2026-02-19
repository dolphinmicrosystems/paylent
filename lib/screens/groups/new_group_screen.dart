import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paylent/models/group_category.dart';
import 'package:paylent/models/group_draft_provider.dart';
import 'package:paylent/models/participants_screen_mode.dart';
import 'package:paylent/screens/contacts/participants_selection_screen.dart';

class NewGroupScreen extends ConsumerStatefulWidget {
  const NewGroupScreen({super.key});

  @override
  ConsumerState<NewGroupScreen> createState() => _NewGroupScreenState();
}

class _NewGroupScreenState extends ConsumerState<NewGroupScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? _coverImage;
  GroupCategory _selectedCategory = GroupCategory.trip;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _coverImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Create a Group'),
          leading: BackButton(
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Upload cover image
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(12),
                      image: _coverImage != null
                          ? DecorationImage(
                              image: FileImage(_coverImage!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _coverImage == null
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload, size: 28),
                              SizedBox(height: 8),
                              Text('Upload Cover Image'),
                            ],
                          )
                        : null,
                  ),
                ),

                const SizedBox(height: 24),

                // Title
                const Text('Title'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _titleController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _inputDecoration('Title'),
                  validator: (final value) {
                    if (value == null || value.trim().isEmpty) {
                      return '';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Description
                const Text('Description'),
                const SizedBox(height: 6),
                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: _inputDecoration('Description'),
                ),

                const SizedBox(height: 16),

                // Category
                const Text('Category'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: GroupCategory.values.map((final cat) {
                    final String name = cat.name;
                    final dynamic iconData = cat.emoji;
                    final bool selected = _selectedCategory == GroupCategory.fromString(name);
                    return ChoiceChip(
                      showCheckmark: false,
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          const SizedBox(
                              width: 8), // Space between text and icon
                          _buildIcon(iconData),
                        ],
                      ),
                      selected: selected,
                      onSelected: (final isSelected) {
                        setState(() {
                          _selectedCategory = isSelected ? GroupCategory.fromString(name) : GroupCategory.other;
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 32),

                // Bottom buttons
                Row(
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
                          if (_formKey.currentState!.validate()) {
                            ref.read(groupDraftProvider.notifier).start(
                                title: _titleController.text.trim(),
                                description: _descriptionController.text.trim(),
                                category: _selectedCategory,
                                imagePath: _coverImage?.path,
                              );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (final _) => const ParticipantsScreen(
                                  mode: ParticipantsScreenMode.createGroup,
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text('Continue'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildIcon(final dynamic iconData) {
    if (iconData is String) {
      // Emoji
      return Text(
        iconData,
        style: const TextStyle(fontSize: 20),
      );
    } else if (iconData is IconData) {
      // Material icon
      return Icon(iconData, size: 20);
    }

    return const SizedBox.shrink();
  }

  InputDecoration _inputDecoration(final String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade900,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      );
}
