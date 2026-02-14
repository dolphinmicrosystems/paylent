import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/models/contact_info.dart';
import 'package:paylent/providers/contacts_notifier.dart';

class ContactDetailScreen extends ConsumerStatefulWidget {
  final String contactId;

  const ContactDetailScreen({required this.contactId, super.key});

  @override
  ConsumerState<ContactDetailScreen> createState() =>
      _ContactDetailScreenState();
}

class _ContactDetailScreenState extends ConsumerState<ContactDetailScreen> {
  Contact? _edited;
  bool _isEditing = false;
  TextEditingController? _nameController;
  TextEditingController? _emailController;

  @override
  void dispose() {
    _nameController?.dispose();
    _emailController?.dispose();
    super.dispose();
  }

  bool get _hasChanges {
    final notifier = ref.read(notifierProvider.notifier);
    final original = notifier.getByIdSafe(widget.contactId);
    final edited = _edited;

    if (original == null || edited == null) return false;

    return edited.name != original.name || edited.email != original.email;
  }

  Future<bool> _showConfirmDialog() async {
    if (!_hasChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (final _) => AlertDialog(
        title: const Text('Confirm update'),
        content:
            const Text('Are you sure you want to update the contact details?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<void> _handleSave() async {
    final edited = _edited;
    if (edited == null) return;

    final confirmed = await _showConfirmDialog();
    if (!mounted) return;
    if (!confirmed) return;

    ref.read(notifierProvider.notifier).update(edited);
    Navigator.pop(context, edited);
  }

  Future<void> _delete() async {
    ref.read(notifierProvider.notifier).delete(widget.contactId);
    Navigator.pop(context, widget.contactId);
  }

  Future<bool> _confirmLeave() async {
    if (!_hasChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (final _) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('You have unsaved changes. Do you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Widget _buildScaffold(final BuildContext context) {
    final edited = _edited!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (final didPop, final _) async {
        if (didPop) return;

        final canLeave = await _confirmLeave();
        if (canLeave) {
          if (!mounted) return;
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Contact'),
          leading: const BackButton(),
          actions: [
            Icon(
              Icons.star,
              color: edited.isFavorite ? Colors.amber : Colors.grey,
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 40),
            GestureDetector(
              onDoubleTap: () => setState(() => _isEditing = true),
              child: CircleAvatar(
                radius: 48,
                backgroundImage: NetworkImage(edited.avatarUrl),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onDoubleTap: () => setState(() => _isEditing = true),
              child: _isEditing
                  ? TextField(
                      controller: _nameController!,
                      onChanged: (final v) => setState(() {
                        _edited = edited.copyWith(name: v);
                      }),
                    )
                  : Text(
                      edited.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onDoubleTap: () => setState(() => _isEditing = true),
              child: _isEditing
                  ? TextField(
                      controller: _emailController!,
                      onChanged: (final v) => setState(() {
                        _edited = edited.copyWith(email: v);
                      }),
                    )
                  : Text(
                      edited.email,
                      style: const TextStyle(color: Colors.grey),
                    ),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 32),
            if (_isEditing)
              ElevatedButton(
                onPressed: _handleSave,
                child: const Text('Save Changes'),
              ),
            const SizedBox(height: 12),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
              onPressed: _delete,
              child: const Text('Delete Contact'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final contactsAsync = ref.watch(notifierProvider);

    return contactsAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (final _, final __) => const Scaffold(
        body: Center(child: Text('Error loading contact')),
      ),
      data: (final contacts) {
        Contact? contact;

        for (final c in contacts) {
          if (c.id == widget.contactId) {
            contact = c;
            break;
          }
        }

        if (contact == null) {
          return const Scaffold(
            body: Center(child: Text('Contact not found')),
          );
        }

        // Initialize once
        if (_edited == null) {
          _edited = contact.copy();
          _nameController = TextEditingController(text: contact.name);
          _emailController = TextEditingController(text: contact.email);
        }

        return _buildScaffold(context);
      },
    );
  }
}
