import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../models/expense_category.dart';
import '../models/financial_progress_item.dart';
import '../models/insight.dart';
import '../../core/constants/colors.dart';

/// Service responsible for fetching dashboard data
/// In a real app, this would make API calls to your backend
class DashboardService {
  // Simulates a network delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  /// Fetch expense categories by time period
  Future<List<ExpenseCategory>> getExpenseCategories(String period) async {
    await _simulateNetworkDelay();
    
    // Simulated API response based on period
    switch (period) {
      case 'Weekly':
        return [
          ExpenseCategory(label: 'Food', value: 35.0, color: AppColors.error),
          ExpenseCategory(label: 'Transport', value: 30.0, color: AppColors.categoryTransport),
          ExpenseCategory(label: 'Shopping', value: 20.0, color: AppColors.categoryShopping),
          ExpenseCategory(label: 'Bills', value: 15.0, color: AppColors.categoryBills),
        ];
      case 'Yearly':
        return [
          ExpenseCategory(label: 'Food', value: 30.0, color: AppColors.error),
          ExpenseCategory(label: 'Transport', value: 20.0, color: AppColors.categoryTransport),
          ExpenseCategory(label: 'Shopping', value: 25.0, color: AppColors.categoryShopping),
          ExpenseCategory(label: 'Bills', value: 25.0, color: AppColors.categoryBills),
        ];
      case 'Monthly':
      default:
        return [
          ExpenseCategory(label: 'Food', value: 40.0, color: AppColors.error),
          ExpenseCategory(label: 'Transport', value: 25.0, color: AppColors.categoryTransport),
          ExpenseCategory(label: 'Shopping', value: 20.0, color: AppColors.categoryShopping),
          ExpenseCategory(label: 'Bills', value: 15.0, color: AppColors.categoryBills),
        ];
    }
  }

  /// Fetch recent activities
  Future<List<Activity>> getRecentActivities() async {
    await _simulateNetworkDelay();
    
    // Simulated API response
    return [
      Activity(
        label: 'Coffee',
        category: 'Food',
        amount: '-4.50',
        color: AppColors.error,
        icon: Icons.local_cafe,
        date: 'Today',
      ),
      Activity(
        label: 'Uber',
        category: 'Transport',
        amount: '-12.00',
        color: AppColors.categoryTransport,
        icon: Icons.directions_car,
        date: 'Yesterday',
      ),
      Activity(
        label: 'Salary',
        category: 'Income',
        amount: '+1500.00',
        color: AppColors.success,
        icon: Icons.attach_money,
        date: '2 days ago',
      ),
      Activity(
        label: 'Grocery Shopping',
        category: 'Food',
        amount: '-85.75',
        color: AppColors.error,
        icon: Icons.shopping_cart,
        date: '3 days ago',
      ),
      Activity(
        label: 'Movie Tickets',
        category: 'Entertainment',
        amount: '-24.99',
        color: Colors.purple,
        icon: Icons.movie,
        date: '4 days ago',
      ),
      Activity(
        label: 'Electricity Bill',
        category: 'Bills',
        amount: '-120.50',
        color: AppColors.categoryBills,
        icon: Icons.bolt,
        date: 'Last week',
      ),
      Activity(
        label: 'Freelance Work',
        category: 'Income',
        amount: '+350.00',
        color: AppColors.success,
        icon: Icons.work,
        date: 'Last week',
      ),
    ];
  }

  /// Fetch financial progress data
  Future<List<FinancialProgressItem>> getFinancialProgress() async {
    await _simulateNetworkDelay();
    
    // Simulated API response
    return [
      FinancialProgressItem(
        title: 'Monthly Budget',
        progress: 0.65,
        description: 'You\'ve used 65% of your monthly budget',
        color: AppColors.accent,
      ),
      FinancialProgressItem(
        title: 'Savings Goal',
        progress: 0.40,
        description: 'You\'ve reached 40% of your savings goal',
        color: AppColors.success,
      ),
      FinancialProgressItem(
        title: 'Debt Reduction',
        progress: 0.30,
        description: 'You\'ve paid off 30% of your debt',
        color: AppColors.error,
      ),
    ];
  }

  /// Fetch AI insights
  Future<List<Insight>> getAIInsights() async {
    await _simulateNetworkDelay();
    
    // Simulated API response
    return [
      Insight(
        title: 'Unusual Spending',
        description: 'Your restaurant spending is 40% higher than last month',
        icon: Icons.warning_amber_outlined,
        color: AppColors.error,
        actionLabel: 'View Details',
      ),
      Insight(
        title: 'Savings Opportunity',
        description: 'You could save \$200 by optimizing your subscriptions',
        icon: Icons.savings_outlined,
        color: AppColors.success,
        actionLabel: 'Optimize Now',
      ),
      Insight(
        title: 'Budget Alert',
        description: 'You are approaching your monthly budget limit for Entertainment',
        icon: Icons.notifications_active,
        color: Colors.orange,
        actionLabel: 'View Budget',
      ),
    ];
  }
}
