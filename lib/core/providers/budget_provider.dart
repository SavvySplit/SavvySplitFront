import 'package:flutter/foundation.dart';
import '../models/transaction.dart';
import 'transaction_provider.dart';

class BudgetCategory {
  final String name;
  double budget;
  double spent;
  final List<String> transactionCategories;

  BudgetCategory({
    required this.name,
    required this.budget,
    this.spent = 0,
    List<String>? transactionCategories,
  }) : transactionCategories = transactionCategories ?? [name.toUpperCase()];

  double get percentage => budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0;

  void updateSpending(double newSpent) {
    spent = newSpent;
  }

  // Convert to map for serialization
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'budget': budget,
      'spent': spent,
      'transactionCategories': transactionCategories,
    };
  }

  // Create from map for deserialization
  factory BudgetCategory.fromMap(Map<String, dynamic> map) {
    return BudgetCategory(
      name: map['name'] as String,
      budget: (map['budget'] as num).toDouble(),
      spent: (map['spent'] as num).toDouble(),
      transactionCategories: List<String>.from(
        map['transactionCategories'] as List<dynamic>,
      ),
    );
  }
}

class BudgetProvider extends ChangeNotifier {
  double _monthlyBudget = 0;
  DateTime _selectedMonth = DateTime.now();
  final List<BudgetCategory> _categories = [];

  // Store monthly budgets
  final Map<String, Map<String, dynamic>> _monthlyBudgets = {};

  double get monthlyBudget => _monthlyBudget;
  double get spent => _categories.fold(0, (sum, cat) => sum + cat.spent);
  double get remaining => (_monthlyBudget - spent).clamp(0, double.infinity);
  double get percentage =>
      _monthlyBudget > 0 ? (spent / _monthlyBudget).clamp(0, 1) : 0;
  List<BudgetCategory> get categories => _categories;

  // Initialize with default categories if none exist
  void initialize() {
    // Initialize with default categories if none exist
    if (_categories.isEmpty) {
      _categories.addAll([
        BudgetCategory(
          name: 'Food & Dining',
          budget: 400,
          transactionCategories: ['FOOD', 'DINING', 'RESTAURANT', 'GROCERY'],
        ),
        BudgetCategory(
          name: 'Shopping',
          budget: 300,
          transactionCategories: ['SHOPPING', 'CLOTHING', 'ELECTRONICS'],
        ),
        BudgetCategory(
          name: 'Transportation',
          budget: 200,
          transactionCategories: ['TRANSPORT', 'GAS', 'PARKING', 'UBER'],
        ),
        BudgetCategory(
          name: 'Entertainment',
          budget: 150,
          transactionCategories: ['ENTERTAINMENT', 'MOVIES', 'GAMES'],
        ),
        BudgetCategory(
          name: 'Bills & Utilities',
          budget: 350,
          transactionCategories: ['BILLS', 'UTILITIES', 'INTERNET', 'PHONE'],
        ),
        BudgetCategory(name: 'Others', budget: 100, transactionCategories: []),
      ]);
      _monthlyBudget = _categories.fold(0, (sum, cat) => sum + cat.budget);
    }
    notifyListeners();
  }

  // Update spending based on transaction data
  void updateFromTransactions(TransactionProvider transactionProvider) {
    // Reset all spending to zero
    for (var category in _categories) {
      category.updateSpending(0);
    }

    // Calculate spending per category
    final transactions = transactionProvider.transactions;
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);

    // Filter transactions for current month
    final monthlyTransactions = transactions.where(
      (t) =>
          t.date.isAfter(currentMonth) &&
          t.date.isBefore(DateTime(now.year, now.month + 1)),
    );

    // Group transactions by category
    final categorySpending = <String, double>{};

    for (var transaction in monthlyTransactions) {
      if (transaction.amount < 0) {
        // Only process expenses
        final amount = transaction.amount.abs();
        final category = _categorizeTransaction(transaction);
        categorySpending[category] = (categorySpending[category] ?? 0) + amount;
      }
    }

    // Update category spending
    for (var category in _categories) {
      final spent = categorySpending[category.name] ?? 0;
      category.updateSpending(spent);
    }

    notifyListeners();
  }

  String _categorizeTransaction(Transaction transaction) {
    // Find the first budget category that matches the transaction category
    for (var category in _categories) {
      if (category.transactionCategories.any(
        (cat) => transaction.category.toUpperCase().contains(cat),
      )) {
        return category.name;
      }
    }
    return 'Others';
  }

  // Get current month key (e.g., '2023-05')
  String get _currentMonthKey =>
      '${_selectedMonth.year}-${_selectedMonth.month.toString().padLeft(2, '0')}';

  // Update selected month
  void updateSelectedMonth(DateTime month) {
    _selectedMonth = DateTime(month.year, month.month);
    _loadBudgetForMonth();
    notifyListeners();
  }

  // Load budget for selected month
  void _loadBudgetForMonth() {
    final data = _monthlyBudgets[_currentMonthKey];
    if (data != null) {
      _monthlyBudget = data['monthlyBudget'] ?? 0;
      _categories.clear();
      _categories.addAll(
        (data['categories'] as List).map((c) => BudgetCategory.fromMap(c)),
      );
    } else {
      // Initialize new month with default values or copy from previous month
      _monthlyBudget =
          _monthlyBudget; // Keep current budget or calculate based on previous months
      _updateCategoryBudgets();
    }
  }

  // Suggest budget based on past spending
  void suggestBudgets(TransactionProvider transactionProvider) {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1);
    final twoMonthsAgo = DateTime(now.year, now.month - 2);

    // Calculate average spending for each category
    final categorySpending = <String, double>{};

    for (var month in [lastMonth, twoMonthsAgo]) {
      final monthKey =
          '${month.year}-${month.month.toString().padLeft(2, '0')}';
      final data = _monthlyBudgets[monthKey];
      if (data != null) {
        final categories = (data['categories'] as List).map(
          (c) => BudgetCategory.fromMap(c),
        );
        for (var category in categories) {
          categorySpending[category.name] =
              (categorySpending[category.name] ?? 0) + category.spent;
        }
      }
    }

    // Update current month's budgets with suggestions
    for (var category in _categories) {
      final avgSpending =
          (categorySpending[category.name] ?? 0) /
          2; // Average of last 2 months
      final suggestedBudget =
          (avgSpending * 1.1).roundToDouble(); // Add 10% buffer
      category.budget = suggestedBudget > 0 ? suggestedBudget : category.budget;
    }

    _saveCurrentBudget();
    notifyListeners();
  }

  // Save current budget data
  void _saveCurrentBudget() {
    _monthlyBudgets[_currentMonthKey] = {
      'categories': _categories.map((c) => c.toMap()).toList(),
      'monthlyBudget': _monthlyBudget,
    };
  }

  // Update category budgets based on monthly budget
  void _updateCategoryBudgets() {
    final totalBudgeted = _categories.fold(0.0, (sum, cat) => sum + cat.budget);
    if (totalBudgeted > 0) {
      final ratio = _monthlyBudget / totalBudgeted;
      for (var category in _categories) {
        category.budget = (category.budget * ratio).roundToDouble();
      }
    }
    _saveCurrentBudget();
  }

  void updateMonthlyBudget(double newBudget) {
    _monthlyBudget = newBudget;
    _updateCategoryBudgets();
    _saveCurrentBudget();
    notifyListeners();
  }

  void updateCategoryBudget(String categoryName, double newBudget) {
    final index = _categories.indexWhere((c) => c.name == categoryName);
    if (index != -1) {
      _categories[index].budget = newBudget;
      _saveCurrentBudget();
      _monthlyBudget = _categories.fold(0, (sum, cat) => sum + cat.budget);
      notifyListeners();
    }
  }

  void addCategory(
    String name,
    double budget, {
    List<String>? transactionCategories,
  }) {
    _categories.add(
      BudgetCategory(
        name: name,
        budget: budget,
        transactionCategories: transactionCategories ?? [name.toUpperCase()],
      ),
    );
    _saveCurrentBudget();
    notifyListeners();
  }

  void removeCategory(String name) {
    _categories.removeWhere((category) => category.name == name);
    _saveCurrentBudget();
    notifyListeners();
  }

  void resetSpending() {
    for (var category in _categories) {
      category.spent = 0;
    }
    _saveCurrentBudget();
    notifyListeners();
  }
}
