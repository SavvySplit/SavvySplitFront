import 'package:flutter/foundation.dart';

class Goal {
  final String id;
  final String title;
  final double currentAmount;
  final double targetAmount;
  final double monthlyContribution;
  final DateTime targetDate;

  Goal({
    required this.id,
    required this.title,
    required this.currentAmount,
    required this.targetAmount,
    required this.monthlyContribution,
    required this.targetDate,
  });

  double get progress => (currentAmount / targetAmount) * 100;
  double get progressFraction => currentAmount / targetAmount;

  bool get isCompleted => currentAmount >= targetAmount;

  int get monthsLeft {
    final now = DateTime.now();
    final months =
        (targetDate.year - now.year) * 12 + targetDate.month - now.month;
    return months > 0 ? months : 0;
  }
}

class GoalProvider extends ChangeNotifier {
  List<Goal> _goals = [];

  List<Goal> get goals => _goals;

  Future<void> fetchGoals() async {
    // Mock implementation - would be replaced with real API calls
    await Future.delayed(const Duration(milliseconds: 500));

    _goals = [
      Goal(
        id: '1',
        title: 'Emergency Fund',
        currentAmount: 15000.00,
        targetAmount: 45000.00,
        monthlyContribution: 300.00,
        targetDate: DateTime.now().add(const Duration(days: 365 * 3)),
      ),
      Goal(
        id: '2',
        title: 'House Down Payment',
        currentAmount: 25000.00,
        targetAmount: 60000.00,
        monthlyContribution: 1000.00,
        targetDate: DateTime.now().add(const Duration(days: 365 * 2)),
      ),
      Goal(
        id: '3',
        title: 'Vacation',
        currentAmount: 1500.00,
        targetAmount: 3000.00,
        monthlyContribution: 250.00,
        targetDate: DateTime.now().add(const Duration(days: 180)),
      ),
    ];

    notifyListeners();
  }

  void addGoal({
    required String title,
    required double targetAmount,
    required double initialAmount,
    required double monthlyContribution,
    required DateTime targetDate,
  }) {
    final newGoal = Goal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      currentAmount: initialAmount,
      targetAmount: targetAmount,
      monthlyContribution: monthlyContribution,
      targetDate: targetDate,
    );

    _goals.add(newGoal);
    notifyListeners();
  }

  void updateGoal(Goal updatedGoal) {
    final index = _goals.indexWhere((goal) => goal.id == updatedGoal.id);
    if (index != -1) {
      _goals[index] = updatedGoal;
      notifyListeners();
    }
  }

  void deleteGoal(String id) {
    _goals.removeWhere((goal) => goal.id == id);
    notifyListeners();
  }

  void addContribution(String id, double amount) {
    final index = _goals.indexWhere((goal) => goal.id == id);
    if (index != -1) {
      final goal = _goals[index];
      final updatedGoal = Goal(
        id: goal.id,
        title: goal.title,
        currentAmount: goal.currentAmount + amount,
        targetAmount: goal.targetAmount,
        monthlyContribution: goal.monthlyContribution,
        targetDate: goal.targetDate,
      );
      _goals[index] = updatedGoal;
      notifyListeners();
    }
  }
}
