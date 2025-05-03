import '../models/activity.dart';
import '../models/expense_category.dart';
import '../models/financial_progress_item.dart';
import '../models/insight.dart';
import '../services/dashboard_service.dart';

/// Repository that handles dashboard data operations
/// Acts as a mediator between data sources and the UI
class DashboardRepository {
  final DashboardService _dashboardService;
  
  // Cache for data
  List<ExpenseCategory>? _cachedCategories;
  List<Activity>? _cachedActivities;
  List<FinancialProgressItem>? _cachedFinancialProgress;
  List<Insight>? _cachedInsights;
  String? _lastPeriod;
  DateTime _lastRefresh = DateTime.now();
  
  // Singleton pattern
  static final DashboardRepository _instance = DashboardRepository._internal();
  
  factory DashboardRepository() {
    return _instance;
  }
  
  DashboardRepository._internal() : _dashboardService = DashboardService();
  
  /// Clear all cached data to force a refresh
  void clearCache() {
    _cachedCategories = null;
    _cachedActivities = null;
    _cachedFinancialProgress = null;
    _cachedInsights = null;
    _lastPeriod = null;
  }
  
  /// Get expense categories by period with caching
  Future<List<ExpenseCategory>> getExpenseCategories(String period) async {
    // Check if cache is valid and period hasn't changed
    if (_cachedCategories != null && 
        _lastPeriod == period && 
        DateTime.now().difference(_lastRefresh).inMinutes < 5) {
      return _cachedCategories!;
    }
    
    final categories = await _dashboardService.getExpenseCategories(period);
    
    // Update cache
    _cachedCategories = categories;
    _lastPeriod = period;
    _lastRefresh = DateTime.now();
    
    return categories;
  }
  
  /// Get recent activities with caching
  Future<List<Activity>> getRecentActivities() async {
    // Check if cache is valid
    if (_cachedActivities != null && 
        DateTime.now().difference(_lastRefresh).inMinutes < 5) {
      return _cachedActivities!;
    }
    
    final activities = await _dashboardService.getRecentActivities();
    
    // Update cache
    _cachedActivities = activities;
    _lastRefresh = DateTime.now();
    
    return activities;
  }
  
  /// Get financial progress with caching
  Future<List<FinancialProgressItem>> getFinancialProgress() async {
    // Check if cache is valid
    if (_cachedFinancialProgress != null && 
        DateTime.now().difference(_lastRefresh).inMinutes < 5) {
      return _cachedFinancialProgress!;
    }
    
    final progress = await _dashboardService.getFinancialProgress();
    
    // Update cache
    _cachedFinancialProgress = progress;
    _lastRefresh = DateTime.now();
    
    return progress;
  }
  
  /// Get AI insights with caching
  Future<List<Insight>> getAIInsights() async {
    // Check if cache is valid
    if (_cachedInsights != null && 
        DateTime.now().difference(_lastRefresh).inMinutes < 5) {
      return _cachedInsights!;
    }
    
    final insights = await _dashboardService.getAIInsights();
    
    // Update cache
    _cachedInsights = insights;
    _lastRefresh = DateTime.now();
    
    return insights;
  }
  
  /// Delete an activity by position
  Future<void> deleteActivity(int index) async {
    if (_cachedActivities != null && index < _cachedActivities!.length) {
      // Remove from cache
      _cachedActivities!.removeAt(index);
      
      // In a real app, you would make an API call here to update the backend
      // await _dashboardService.deleteActivity(id);
    }
  }
  
  /// Add back a previously deleted activity
  Future<void> undoDeleteActivity(int index, Activity activity) async {
    if (_cachedActivities != null) {
      // Insert back to cache
      if (index < _cachedActivities!.length) {
        _cachedActivities!.insert(index, activity);
      } else {
        _cachedActivities!.add(activity);
      }
      
      // In a real app, you would make an API call here to update the backend
      // await _dashboardService.addActivity(activity);
    }
  }
}
