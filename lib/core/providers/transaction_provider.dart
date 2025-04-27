import 'package:flutter/foundation.dart';
import '../models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;
  
  Future<void> fetchTransactions() async {
    // Mock implementation - would be replaced with real API calls
    await Future.delayed(const Duration(milliseconds: 500));
    
    _transactions = [
      Transaction(
        id: '1',
        description: 'Uber Ride',
        amount: -35.50,
        category: 'TRANSPORT',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Transaction(
        id: '2',
        description: 'Electric Bill',
        amount: -89.99,
        category: 'BILLS',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Transaction(
        id: '3',
        description: 'Shopping Mall',
        amount: -120.00,
        category: 'SHOPPING',
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Transaction(
        id: '4',
        description: 'Grocery Shopping',
        amount: -45.99,
        category: 'FOOD',
        date: DateTime.now(),
      ),
      Transaction(
        id: '5',
        description: 'Monthly Salary',
        amount: 1200.00,
        category: 'INCOME',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
    
    notifyListeners();
  }

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  void removeTransaction(String id) {
    _transactions.removeWhere((transaction) => transaction.id == id);
    notifyListeners();
  }

  void updateTransaction(Transaction transaction) {
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      _transactions[index] = transaction;
      notifyListeners();
    }
  }

  double getTotalSpent() {
    return _transactions
        .where((transaction) => transaction.amount < 0)
        .fold(0, (sum, transaction) => sum + transaction.amount.abs());
  }

  double getTotalIncome() {
    return _transactions
        .where((transaction) => transaction.amount > 0)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  double getBalance() {
    return _transactions.fold(
        0, (sum, transaction) => sum + transaction.amount);
  }

  Map<String, double> getCategoryBreakdown() {
    final Map<String, double> breakdown = {};
    
    for (var transaction in _transactions) {
      if (transaction.amount < 0) { // Only include expenses
        final category = transaction.category;
        breakdown[category] = (breakdown[category] ?? 0) + transaction.amount.abs();
      }
    }
    
    return breakdown;
  }
}
