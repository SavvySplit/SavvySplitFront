import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants/colors.dart';
import '../models/group.dart';
import '../models/group_analytics.dart';

class EnhancedExpenseDialog extends StatefulWidget {
  final Group group;

  const EnhancedExpenseDialog({required this.group, Key? key})
    : super(key: key);

  @override
  State<EnhancedExpenseDialog> createState() => _EnhancedExpenseDialogState();
}

class _EnhancedExpenseDialogState extends State<EnhancedExpenseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedCategory = 'Food';
  String _selectedPaidBy = '1'; // Default to current user
  SplitType _splitType = SplitType.equal;
  bool _isRecurring = false;
  RecurringFrequency _recurringFrequency = RecurringFrequency.monthly;
  DateTime _selectedDate = DateTime.now();

  final List<String> _categories = [
    'Food',
    'Entertainment',
    'Transportation',
    'Groceries',
    'Utilities',
    'Rent',
    'Shopping',
    'Other',
  ];

  // Map to store custom split amounts for each member
  final Map<String, double> _customSplits = {};

  @override
  void initState() {
    super.initState();
    // Initialize custom splits with equal amounts
    _initializeCustomSplits();
  }

  void _initializeCustomSplits() {
    if (_amountController.text.isNotEmpty) {
      final amount = double.tryParse(_amountController.text) ?? 0.0;
      final equalShare = amount / widget.group.members.length;

      for (var member in widget.group.members) {
        _customSplits[member.id] = equalShare;
      }
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              border: Border.all(
                color: AppColors.borderPrimary.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 15,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              children: [
                // Handle bar for dragging
                Container(
                  margin: EdgeInsets.only(top: 16, bottom: 8),
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderPrimary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add New Expense',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color: AppColors.textSecondary,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBasicInfoSection(),
                          const SizedBox(height: 24),
                          _buildSplitSection(),
                          const SizedBox(height: 24),
                          _buildRecurringSection(),
                          const SizedBox(height: 24),
                          _buildAdditionalInfoSection(),
                        ],
                      ),
                    ),
                  ),
                ),
                // Action buttons
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    border: Border(
                      top: BorderSide(
                        color: AppColors.borderPrimary.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Handle expense creation
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentGradientMiddle,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Save Expense',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Basic Information',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: InputDecoration(
            labelText: 'Description',
            labelStyle: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
            filled: true,
            fillColor: AppColors.background.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          style: const TextStyle(color: AppColors.textPrimary),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a description';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _amountController,
          decoration: InputDecoration(
            labelText: 'Amount',
            labelStyle: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
            filled: true,
            fillColor: AppColors.background.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            prefixIcon: const Icon(
              Icons.attach_money,
              color: AppColors.textSecondary,
            ),
          ),
          keyboardType: TextInputType.number,
          style: const TextStyle(color: AppColors.textPrimary),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an amount';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
          onChanged: (value) {
            // Update custom splits when amount changes
            if (value.isNotEmpty) {
              setState(() {
                final amount = double.tryParse(value) ?? 0.0;
                final equalShare = amount / widget.group.members.length;

                for (var member in widget.group.members) {
                  _customSplits[member.id] = equalShare;
                }
              });
            }
          },
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                menuMaxHeight: 300,
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: TextStyle(
                    color: AppColors.textSecondary.withOpacity(0.7),
                  ),
                  filled: true,
                  fillColor: AppColors.background.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                isExpanded: true,
                items:
                    _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(
                          category,
                          style: const TextStyle(color: AppColors.textPrimary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                value: _selectedCategory,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
                dropdownColor: AppColors.cardBackground,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                menuMaxHeight: 300,
                decoration: InputDecoration(
                  labelText: 'Paid by',
                  labelStyle: TextStyle(
                    color: AppColors.textSecondary.withOpacity(0.7),
                  ),
                  filled: true,
                  fillColor: AppColors.background.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                isExpanded: true,
                items:
                    widget.group.members.map((member) {
                      return DropdownMenuItem(
                        value: member.id,
                        child: Text(
                          member.id == '1' ? 'You' : member.name,
                          style: const TextStyle(color: AppColors.textPrimary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                value: _selectedPaidBy,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedPaidBy = value;
                    });
                  }
                },
                dropdownColor: AppColors.cardBackground,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: AppColors.accentGradientMiddle,
                      onPrimary: Colors.white,
                      surface: AppColors.cardBackground,
                      onSurface: AppColors.textPrimary,
                    ),
                    dialogBackgroundColor: AppColors.cardBackground,
                  ),
                  child: child!,
                );
              },
            );

            if (date != null) {
              setState(() {
                _selectedDate = date;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.background.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
                const SizedBox(width: 12),
                Text(
                  'Date: ${DateFormat('MMM dd, yyyy').format(_selectedDate)}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSplitSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Split Options',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            _buildSplitTypeChip(SplitType.equal, 'Equal'),
            _buildSplitTypeChip(SplitType.percentage, 'Percentage'),
            _buildSplitTypeChip(SplitType.exact, 'Exact Amounts'),
            _buildSplitTypeChip(SplitType.shares, 'Shares'),
          ],
        ),
        const SizedBox(height: 16),
        if (_splitType != SplitType.equal)
          Column(
            children:
                widget.group.members.map((member) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(member.imageUrl),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: Text(
                            member.id == '1' ? 'You' : member.name,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            initialValue:
                                _customSplits[member.id]?.toString() ?? '0.0',
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.background.withOpacity(0.3),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              prefixText:
                                  _splitType == SplitType.exact
                                      ? r'$ ' // Dollar sign for exact amounts
                                      : _splitType == SplitType.percentage
                                      ? '% ' // Percentage sign for percentages
                                      : null,
                              prefixStyle: TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                            ),
                            onChanged: (value) {
                              final amount = double.tryParse(value) ?? 0.0;
                              setState(() {
                                _customSplits[member.id] = amount;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        if (_splitType == SplitType.equal)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.accentGradientMiddle.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.accentGradientMiddle,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Each person will pay ${_amountController.text.isNotEmpty ? '\$${(double.tryParse(_amountController.text) ?? 0.0 / widget.group.members.length).toStringAsFixed(2)}' : '\$0.00'}',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSplitTypeChip(SplitType type, String label) {
    final isSelected = _splitType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _splitType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.accentGradientMiddle
                  : AppColors.background.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildRecurringSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Recurring Expense',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Switch(
              value: _isRecurring,
              onChanged: (value) {
                setState(() {
                  _isRecurring = value;
                });
              },
              activeColor: AppColors.accentGradientMiddle,
              activeTrackColor: AppColors.accentGradientMiddle.withOpacity(0.3),
            ),
          ],
        ),
        if (_isRecurring)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text(
                'Frequency',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildFrequencyChip(RecurringFrequency.daily, 'Daily'),
                  _buildFrequencyChip(RecurringFrequency.weekly, 'Weekly'),
                  _buildFrequencyChip(RecurringFrequency.monthly, 'Monthly'),
                  _buildFrequencyChip(RecurringFrequency.yearly, 'Yearly'),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accentGradientMiddle.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.accentGradientMiddle,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'This expense will automatically repeat based on the selected frequency',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildFrequencyChip(RecurringFrequency frequency, String label) {
    final isSelected = _recurringFrequency == frequency;

    return GestureDetector(
      onTap: () {
        setState(() {
          _recurringFrequency = frequency;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.accentGradientMiddle
                  : AppColors.background.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Information',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _notesController,
          decoration: InputDecoration(
            labelText: 'Notes (optional)',
            labelStyle: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
            filled: true,
            fillColor: AppColors.background.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          style: const TextStyle(color: AppColors.textPrimary),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            // Handle receipt upload
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.background.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.accentGradientMiddle.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt,
                  color: AppColors.accentGradientMiddle,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Add Receipt Photo',
                  style: TextStyle(
                    color: AppColors.accentGradientMiddle,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
