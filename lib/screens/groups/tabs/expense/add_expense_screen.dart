import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:paylent/app_nav.dart';
import 'package:paylent/models/contact_info.dart';
import 'package:paylent/models/currency_model.dart';
import 'package:paylent/models/transaction_category.dart';
import 'package:paylent/models/transaction_model.dart';
import 'package:paylent/providers/contacts_provider.dart';
import 'package:paylent/providers/current_user_provider.dart';
import 'package:paylent/providers/transactions_provider.dart';
import 'package:paylent/screens/groups/tabs/expense/category_selection_screen.dart';
import 'package:paylent/screens/groups/tabs/expense/currency_selection_screen.dart';
import 'package:paylent/screens/groups/tabs/expense/paid_by_selection_screen.dart';
import 'package:paylent/screens/groups/tabs/expense/split_by_selection_screen..dart';
import 'package:paylent/utils/contact_display.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  final bool isEdit;
  final Transaction? transaction;
  final String groupId;
  const AddExpenseScreen(
      {required this.groupId,
      this.isEdit = false,
      this.transaction,
      super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  late final Transaction? _transaction;
  late final bool _isEdit;

  TransactionCategory _selectedCategory = TransactionCategory.general;
  String _selectedCurrencyCode = 'USD';
  DateTime _selectedDate = DateTime.now();
  String _splitBy = 'Equally';
  late String _paidById;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // 1. Get the current user synchronously to set up the initial UI state
    final currentUser = ref.read(currentUserProvider);
    _transaction = widget.transaction;
    _isEdit = widget.isEdit;
    // 2. Schedule the provider update (Safe from "modify during build" error)
    Future.microtask(() {
      ref.read(contactsProvider.notifier).ensureCurrentUser(
            currentUser,
          );
    });

    // 3. Initialize form data
    if (widget.isEdit && _transaction != null) {
      _amountController.text = _transaction.amount.toString();
      _descriptionController.text = _transaction.title;
      _selectedCategory = _transaction.category;

      final dynamic dateRaw = _transaction.date;
      _selectedCurrencyCode = _transaction.currency;

      _selectedDate = (dateRaw is DateTime)
          ? dateRaw
          : (dateRaw is String
              ? DateTime.tryParse(dateRaw) ?? DateTime.now()
              : DateTime.now());

      // PaidBy from existing transaction
      _paidById = _transaction.paidByContactId;
    } else {
      // Default PaidBy = logged-in user
      _paidById = currentUser.id;
    }
  }

  Future<void> _selectDate(final BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final tx = Transaction(
        id: _isEdit
            ? _transaction!.id
            : DateTime.now().millisecondsSinceEpoch.toString(),
        groupId: _transaction?.groupId ?? widget.groupId,
        title: _descriptionController.text.trim(),
        amount: double.parse(_amountController.text),
        date: _selectedDate,
        paidByContactId: _paidById,
        currency: _selectedCurrencyCode,
        category: _selectedCategory,
      );

      final notifier = ref.read(transactionsProvider.notifier);

      if (_isEdit) {
        notifier.update(tx);
      } else {
        notifier.add(tx);
      }

      Navigator.pop(context);
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (final _) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context, 'deleted'); // return result
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final currentUserId = ref.watch(currentUserProvider).id;
    final contacts = ref.watch(contactsProvider);

    final paidByContact = contacts.firstWhere((c) => c.id == _paidById);

    final paidByName = displayName(
      contact: paidByContact,
      currentUserId: currentUserId,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Expense' : 'Add Expense'),
        elevation: 0,
        actions: [
          if (_isEdit)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: Colors.red,
              onPressed: _confirmDelete,
            ),
          IconButton(
            icon: const Icon(Icons.check),
            color: Colors.green,
            onPressed: _submit,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final selectedCurrency = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (final context) => CurrencySelectionScreen(
                            selectedCurrencyCode: _selectedCurrencyCode,
                          ),
                        ),
                      );

                      if (selectedCurrency != null &&
                          selectedCurrency is Currency) {
                        setState(() {
                          _selectedCurrencyCode = selectedCurrency.code;
                        });
                      }
                    },
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedCurrencyCode,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Icon(Icons.arrow_drop_down, size: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: TextFormField(
                      controller: _amountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*$'),
                        ),
                      ],
                      decoration: const InputDecoration(
                        hintText: 'Amount',
                      ),
                      validator: (final value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                  controller: _descriptionController,
                  minLines: 2,
                  maxLines: 4,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                  buildCounter: (
                    final context, {
                    required final int currentLength,
                    required final bool isFocused,
                    required final int? maxLength,
                  }) =>
                      Text(
                        '$currentLength / $maxLength',
                        style: TextStyle(
                          fontSize: 12,
                          color: isFocused ? Colors.grey : Colors.grey.shade500,
                        ),
                      )),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  final result = await AppNav.push(
                    context,
                    CategorySelectionScreen(
                      selectedCategory: _selectedCategory,
                    ),
                  );

                  if (result != null && result is TransactionCategory) {
                    setState(() {
                      _selectedCategory = result;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.category_outlined),
                    suffixIcon: Icon(Icons.chevron_right),
                  ),
                  child: Text(
                    _selectedCategory.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.calendar_today_outlined),
                title: Text('Date: ${DateFormat.yMd().format(_selectedDate)}'),
                trailing: const Icon(Icons.arrow_drop_down),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16),

              /// PAID BY
              InkWell(
                onTap: () async {
                  final result = await AppNav.push(
                    context,
                    PaidBySelectionScreen(
                      selectedValue: _paidById,
                      groupId: widget.groupId,
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      _paidById = result;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Paid by',
                    suffixIcon: Icon(Icons.chevron_right),
                  ),
                  child: Text(paidByName),
                ),
              ),

              const SizedBox(height: 16),

              InkWell(
                onTap: () async {
                  final result = await AppNav.push(
                    context,
                    SplitBySelectionScreen(
                      selectedValue: _splitBy,
                    ),
                  );

                  if (result != null) {
                    setState(() => _splitBy = result);
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Split by',
                    suffixIcon: Icon(Icons.chevron_right),
                  ),
                  child: Text(_splitBy),
                ),
              ),

              const SizedBox(height: 16),

              /// ADD IMAGE BUTTON
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Image picker
                },
                icon: const Icon(Icons.image_outlined),
                label: const Text('Add an Image'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
