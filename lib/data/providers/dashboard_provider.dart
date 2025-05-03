import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../models/expense_category.dart';
import '../models/financial_progress_item.dart';
import '../models/insight.dart';
import '../repositories/dashboard_repository.dart';

/// Provider that manages dashboard data state
/// Uses ChangeNotifier to broadcast state changes to listeners
class DashboardProvider extends ChangeNotifier {
  final DashboardRepository _repository;
  
  // State
  bool _isLoading = false;
  DateTime _lastUpdated = DateTime.now();
  List<ExpenseCategory>? _expenseCategories;
  List<Activity>? _activities;
  List<FinancialProgressItem>? _financialProgress;
  List<Insight>? _insights;
  String _selectedPeriod = 'Monthly';
  String? _selectedSection;
  bool _showAllActivities = false;
  int _activitiesPageSize = 3;
  
  // Getters
  bool get isLoading => _isLoading;
  DateTime get lastUpdated => _lastUpdated;
  List<ExpenseCategory> get expenseCategories => _expenseCategories ?? [];
  List<Activity> get activities => _activities ?? [];
  List<Activity> get displayedActivities => 
      _showAllActivities ? activities : activities.take(_activitiesPageSize).toList();
  List<FinancialProgressItem> get financialProgress => _financialProgress ?? [];
  List<Insight> get insights => _insights ?? [];
  String get selectedPeriod => _selectedPeriod;
  String? get selectedSection => _selectedSection;
  bool get showAllActivities => _showAllActivities;
  bool get hasMoreActivities => activities.length > _activitiesPageSize;
  
  // Singleton pattern
  static final DashboardProvider _instance = DashboardProvider._internal();
  
  factory DashboardProvider() {
    return _instance;
  }
  
  DashboardProvider._internal() : _repository = DashboardRepository();
  
  /// Initialize data
  Future<void> initialize() async {
    await loadDashboardData();
  }
  
  /// Load all dashboard data
  Future<void> loadDashboardData() async {
    if (_isLoading) return;
    
    _setLoading(true);
    
    try {
      // Load data concurrently for better performance
      final results = await Future.wait([
        _repository.getExpenseCategories(_selectedPeriod),
        _repository.getRecentActivities(),
        _repository.getFinancialProgress(),
        _repository.getAIInsights(),
      ]);
      
      // Update state with results
      _expenseCategories = results[0] as List<ExpenseCategory>;
      _activities = results[1] as List<Activity>;
      _financialProgress = results[2] as List<FinancialProgressItem>;
      _insights = results[3] as List<Insight>;
      
      _lastUpdated = DateTime.now();
      _setLoading(false);
      
    } catch (e) {
      // Handle errors
      _setLoading(false);
      debugPrint('Error loading dashboard data: $e');
      // You might want to show an error message to the user
    }
  }
  
  /// Change selected time period and refresh data
  Future<void> changeTimePeriod(String period) async {
    if (_selectedPeriod == period) return;
    
    _selectedPeriod = period;
    _selectedSection = null;
    notifyListeners();
    
    // Load new data for the selected period
    _setLoading(true);
    try {
      _expenseCategories = await _repository.getExpenseCategories(period);
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      debugPrint('Error loading expense categories: $e');
    }
  }
  
  /// Select a section in the expense chart
  void selectChartSection(String? section) {
    _selectedSection = section;
    notifyListeners();
  }
  
  /// Toggle showing all activities
  void toggleShowAllActivities() {
    _showAllActivities = !_showAllActivities;
    notifyListeners();
  }
  
  /// Delete an activity
  Future<void> deleteActivity(int index) async {
    if (_activities != null && index < _activities!.length) {
      // Store for potential undo
      final deletedActivity = _activities![index];
      
      // Remove locally first for immediate UI update
      _activities!.removeAt(index);
      notifyListeners();
      
      // Update in repository (which would normally sync with backend)
      try {
        await _repository.deleteActivity(index);
      } catch (e) {
        // If failed, revert the local change
        _activities!.insert(index, deletedActivity);
        notifyListeners();
        debugPrint('Error deleting activity: $e');
      }
    }
  }
  
  /// Undo delete activity
  Future<void> undoDeleteActivity(int index, Activity activity) async {
    // Update locally first for immediate UI update
    if (_activities != null) {
      if (index < _activities!.length) {
        _activities!.insert(index, activity);
      } else {
        _activities!.add(activity);
      }
      notifyListeners();
      
      // Update in repository
      try {
        await _repository.undoDeleteActivity(index, activity);
      } catch (e) {
        // If failed, revert the local change
        _activities!.remove(activity);
        notifyListeners();
        debugPrint('Error restoring activity: $e');
      }
    }
  }
  
  /// Handle insight action
  void handleInsightAction(Insight insight) {
    // In a real app, you would implement the actual action here
    debugPrint('Handling action for insight: ${insight.title}');
  }
  
  /// Handle insight dismiss
  void dismissInsight(Insight insight) {
    // Remove from the list
    _insights?.remove(insight);
    notifyListeners();
    
    // In a real app, you might want to mark it as read in the backend
    debugPrint('Dismissed insight: ${insight.title}');
  }
  
  // Helper to update loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
