import 'package:flutter/foundation.dart';

class BudgetCategory {
  final String id;
  final String name;
  final double budget;
  final double spent;

  BudgetCategory({
    required this.id,
    required this.name,
    required this.budget,
    required this.spent,
  });

  double get remaining => budget - spent;
  double get percentage => spent / budget;
}

class BudgetProvider extends ChangeNotifier {
  double _monthlyBudget = 5000.00;
  double _spent = 3200.00;
  List<BudgetCategory> _categories = [];

  double get monthlyBudget => _monthlyBudget;
  double get spent => _spent;
  double get remaining => _monthlyBudget - _spent;
  double get percentage => _spent / _monthlyBudget;
  List<BudgetCategory> get categories => _categories;

  Future<void> fetchBudget() async {
    // Mock implementation - would be replaced with real API calls
    await Future.delayed(const Duration(milliseconds: 500));
    
    _monthlyBudget = 5000.00;
    _spent = 3200.00;
    
    _categories = [
      BudgetCategory(
        id: '1',
        name: 'Food',
        budget: 800.00,
        spent: 650.00,
      ),
      BudgetCategory(
        id: '2',
        name: 'Transport',
        budget: 500.00,
        spent: 350.00,
      ),
      BudgetCategory(
        id: '3',
        name: 'Entertainment',
        budget: 400.00,
        spent: 280.00,
      ),
      BudgetCategory(
        id: '4',
        name: 'Shopping',
        budget: 600.00,
        spent: 580.00,
      ),
      BudgetCategory(
        id: '5',
        name: 'Bills',
        budget: 1200.00,
        spent: 1100.00,
      ),
      BudgetCategory(
        id: '6',
        name: 'Others',
        budget: 300.00,
        spent: 240.00,
      ),
    ];
    
    notifyListeners();
  }

  void updateMonthlyBudget(double amount) {
    _monthlyBudget = amount;
    notifyListeners();
  }

  void updateCategoryBudget(String id, double amount) {
    final index = _categories.indexWhere((category) => category.id == id);
    if (index != -1) {
      final category = _categories[index];
      _categories[index] = BudgetCategory(
        id: category.id,
        name: category.name,
        budget: amount,
        spent: category.spent,
      );
      notifyListeners();
    }
  }

  void recordExpense(String categoryId, double amount) {
    final index = _categories.indexWhere((category) => category.id == categoryId);
    if (index != -1) {
      final category = _categories[index];
      _categories[index] = BudgetCategory(
        id: category.id,
        name: category.name,
        budget: category.budget,
        spent: category.spent + amount,
      );
      _spent += amount;
      notifyListeners();
    }
  }
}
