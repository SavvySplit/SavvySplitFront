import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/colors.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../../../../data/providers/auth_provider.dart';

// Widget components
import '../widgets/activity_card.dart';
import '../widgets/load_more_button.dart';
import '../widgets/expense_chart_card.dart';
import '../widgets/quick_actions_card.dart';
import '../widgets/financial_summary_card.dart';
import '../widgets/ai_insights_card.dart';

// Data architecture
import '../../../../data/models/activity.dart';
import '../../../../data/providers/dashboard_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  // Refresh controller
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Animation controller for the notification badge
  late AnimationController _animationController;

  // Accent bar widget for section titles
  final Widget _accentBar = const SizedBox(
    width: 5,
    height: 28,
    child: DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        color: AppColors.accent,
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Simulate a new notification after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _animationController.forward(from: 0.0);
        });
      }
    });

    // Initial data load
    _loadDashboardData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Method to load data using the provider
  Future<void> _loadDashboardData() async {
    final provider = Provider.of<DashboardProvider>(context, listen: false);
    await provider.loadDashboardData();
    return Future.value();
  }

  // Helper for section headers
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _accentBar,
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 18,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  // Skeleton card for loading state
  Widget _buildSkeletonCard({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  // Loading state widget
  Widget _buildLoadingState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildSkeletonCard(
                    width: double.infinity,
                    height: 120,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSkeletonCard(
                    width: double.infinity,
                    height: 120,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Financial summary section
            _buildSectionHeader('Financial Summary'),
            _buildSkeletonCard(width: double.infinity, height: 150),
            const SizedBox(height: 32),

            // Expense chart section
            _buildSectionHeader('Expense Breakdown'),
            _buildSkeletonCard(width: double.infinity, height: 300),
            const SizedBox(height: 32),

            // Recent activity section
            _buildSectionHeader('Recent Activity'),
            _buildSkeletonCard(width: double.infinity, height: 200),
            const SizedBox(height: 32),

            // Quick actions section
            _buildSectionHeader('Quick Actions'),
            _buildSkeletonCard(width: double.infinity, height: 100),
            const SizedBox(height: 32),

            // AI Insights section
            _buildSectionHeader('AI Insights'),
            _buildSkeletonCard(width: double.infinity, height: 150),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style:
                    Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                    ) ??
                    const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                _getTimeBasedGreeting(),
                style: TextStyle(
                  color: AppColors.textPrimary.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.secondary.withOpacity(0.22),
                      shape: const CircleBorder(),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return AnimatedScale(
                          scale: 1.0 + _animationController.value * 0.3,
                          duration: const Duration(milliseconds: 200),
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.redAccent.withOpacity(0.18),
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                '3',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.secondary.withOpacity(0.22),
                  shape: const CircleBorder(),
                ),
              ),
              const SizedBox(width: 8),
              _buildUserAvatar(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final financialItems = dashboardProvider.financialProgress;

    if (financialItems.isEmpty) {
      return Row(
        children: [
          Expanded(
            child: _buildSkeletonCard(width: double.infinity, height: 120),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSkeletonCard(width: double.infinity, height: 120),
          ),
        ],
      );
    }

    // Make the card height more flexible
    const double cardHeight =
        180.0; // Further increased to handle content better

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Income/Expense Summary
        Expanded(
          child: Container(
            height: cardHeight,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF235FA6), Color(0xFF1A4373)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Balance',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '\$3,240.00',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22, // Reduced from 24
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(color: Colors.white24, thickness: 0.5),
                const SizedBox(height: 8),
                // Replace with a simpler layout to avoid overflow
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Income section
                    Flexible(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Income',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '\$5,240',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Expense section
                    Flexible(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Expenses',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '\$2,000',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8), // Reduced from 12
        // Savings Goal Summary
        Expanded(
          child: Container(
            height: cardHeight,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.withOpacity(0.15),
                width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Savings Goal',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    Icon(
                      Icons.savings,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Wrapped in FittedBox to prevent overflow
                const FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Use minimum space needed
                    children: [
                      Text(
                        '\$750',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        ' / \$1,000',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Improved progress bar with better width calculation
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      height: 6,
                      width: constraints.maxWidth, // Use available width
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width:
                                constraints.maxWidth *
                                0.75, // 75% of available width
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.accentGradientStart,
                                  AppColors.accentGradientEnd,
                                ],
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                // Improve responsive layout for the status row
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Summer Vacation',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '75% completed',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialSummary(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final progressItems = dashboardProvider.financialProgress;

    // Convert each FinancialProgressItem to Map<String, dynamic>
    final progressItemMaps = progressItems.map((item) => item.toMap()).toList();

    return FinancialSummaryCard(progressItems: progressItemMaps);
  }

  Widget _buildExpenseChartPlaceholder(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final chartData =
        dashboardProvider.expenseCategories
            .map((category) => category.toMap())
            .toList();

    // Fix the dropdown assertion error by ensuring selectedPeriod is in timePeriods
    const timePeriods = ['Daily', 'Weekly', 'Monthly', 'Yearly'];

    // Use a valid period from the list or default to 'Monthly'
    final selectedPeriod =
        timePeriods.contains(dashboardProvider.selectedPeriod)
            ? dashboardProvider.selectedPeriod
            : 'Monthly';

    return ExpenseChartCard(
      chartData: chartData,
      timePeriods: timePeriods,
      selectedPeriod: selectedPeriod,
      selectedSection: dashboardProvider.selectedSection,
      onPeriodChanged: (period) => dashboardProvider.changeTimePeriod(period),
      onSectionSelected:
          (section) => dashboardProvider.selectChartSection(section),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final activities = dashboardProvider.displayedActivities;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, top: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _accentBar,
              const SizedBox(width: 8),
              const Text(
                'Recent Activities',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ActivityCard(
          activities: activities.map(_convertActivityToMap).toList(),
          onActivityTap: _showActivityDetails,
          onActivityDismiss: _removeActivity,
        ),
        if (dashboardProvider.hasMoreActivities)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: LoadMoreButton(
              isShowingAll: dashboardProvider.showAllActivities,
              onPressed: () => dashboardProvider.toggleShowAllActivities(),
            ),
          ),
      ],
    );
  }

  // Helper method to convert Activity model to Map for the ActivityCard
  Map<String, dynamic> _convertActivityToMap(Activity activity) {
    // Determine if it's an income or expense based on the category
    final isIncome = activity.isIncome;

    return {
      'label': activity.label,
      'category': activity.category,
      'amount': isIncome ? '+${activity.amount}' : activity.amount,
      'color': isIncome ? AppColors.success : AppColors.error,
      'icon': activity.icon,
      'date': activity.date,
    };
  }

  // Event handlers for Recent Activities

  // Generate personalized greeting based on time of day
  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    String timeGreeting;

    if (hour < 12) {
      timeGreeting = 'Good morning';
    } else if (hour < 17) {
      timeGreeting = 'Good afternoon';
    } else {
      timeGreeting = 'Good evening';
    }

    // Get user's name from auth provider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String? userName = authProvider.userName;

    // Extract first name (if there are multiple names)
    String firstName = '';
    if (userName != null && userName.isNotEmpty) {
      // Get first word as first name
      firstName = userName.split(' ').first;
    }

    // Return greeting with user's first name or default message
    return firstName.isNotEmpty
        ? '$timeGreeting, $firstName!'
        : '$timeGreeting!';
  }

  void _showActivityDetails(Map<String, dynamic> activity) {
    // Format the date if it exists
    String formattedDate = '';
    if (activity['date'] != null) {
      try {
        final date = activity['date'] as DateTime;
        formattedDate = DateFormat('MMM d, yyyy').format(date);
      } catch (e) {
        // If date parsing fails, leave empty
      }
    }
    
    // Get the category and amount
    final category = activity['category'] as String? ?? 'Unknown';
    final amount = activity['amount'] as String? ?? '';
    
    // Show enhanced snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 70.0, left: 15.0, right: 15.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.cardBackground,
        duration: const Duration(seconds: 4),
        content: Row(
          children: [
            // Left side - icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: activity['color'] ?? AppColors.accent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                activity['icon'] ?? Icons.receipt_long,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // Middle - activity details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    activity['label'] ?? 'Unknown Activity',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$category${formattedDate.isNotEmpty ? ' • $formattedDate' : ''}',
                    style: TextStyle(
                      color: AppColors.textPrimary.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Right side - amount
            Text(
              amount,
              style: TextStyle(
                color: amount.startsWith('+') ? AppColors.success : AppColors.error,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'View Details',
          textColor: AppColors.accent,
          onPressed: () {
            // Navigate to detailed view (to be implemented)
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Navigating to transaction details (to be implemented)')),
            );
          },
        ),
      ),
    );
  }

  void _removeActivity(int index, Map<String, dynamic> item) {
    final dashboardProvider = Provider.of<DashboardProvider>(
      context,
      listen: false,
    );
    dashboardProvider.deleteActivity(index);

    // Extract necessary data
    final String label = item['label'] as String;
    
    // Show enhanced snackbar with undo functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 70.0, left: 15.0, right: 15.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.cardBackground,
        duration: const Duration(seconds: 6), // Longer duration for undo
        content: Row(
          children: [
            // Success icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // Message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Transaction Deleted',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '"$label" has been removed',
                    style: TextStyle(
                      color: AppColors.textPrimary.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: AppColors.accent,
          onPressed: () {
            // Convert back to Activity and restore
            final activity = Activity(
              label: item['label'],
              category: item['category'],
              amount: item['amount'],
              color: item['color'],
              icon: item['icon'],
              date: item['date'],
            );
            dashboardProvider.undoDeleteActivity(index, activity);
          },
        ),
      ),
    );
  }

  Widget _buildUserAvatar(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Get the user's name from the auth provider
    String? userName = authProvider.userName;

    // Default initial if no user name is available
    String initial = 'U';

    // Extract first letter of user name if available
    if (userName != null && userName.isNotEmpty) {
      initial = userName[0].toUpperCase();
    }

    // Return a circular avatar with the initial
    return GestureDetector(
      onTap: () {
        // Navigate to profile screen or show profile options
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Navigate to Profile')));
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.accentGradientStart,
              AppColors.accentGradientEnd,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentGradientEnd.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Text(
            initial,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actionButtons = [
      {
        'icon': Icons.add_circle,
        'label': 'Add Expense',
        'colorStart': AppColors.accentGradientStart,
        'colorEnd': AppColors.accentGradientEnd,
        'onTap': () {
          // Navigate to groups screen to add an expense
          context.go('/groups');
        },
      },
      {
        'icon': Icons.attach_money,
        'label': 'Add Income',
        'colorStart': AppColors.success,
        'colorEnd': AppColors.success,
        'onTap': () {
          // Navigate to wallet screen to add income
          context.go('/wallet');
        },
      },
      {
        'icon': Icons.group,
        'label': 'Split Bill',
        'colorStart': AppColors.secondary,
        'colorEnd': AppColors.accentGradientEnd,
        'onTap': () {
          // Navigate to groups screen to split a bill
          context.go('/groups');
        },
      },
      {
        'icon': Icons.pie_chart,
        'label': 'Budget',
        'colorStart': const Color(0xFF8A2BE2), // Purple color start
        'colorEnd': const Color(0xFF4B0082), // Purple color end (indigo)
        'onTap': () {
          // Navigate to budget screen
          context.go('/budget');
        },
      },
    ];

    return QuickActionsCard(actions: actionButtons);
  }

  // New enhanced AI insights section with dismiss and action functionality
  Widget _buildEnhancedAIInsights(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final insights = dashboardProvider.insights;

    // Create sample chart data for enhanced insights
    final List<Map<String, dynamic>> spendingTrendData = [
      {'label': 'Jan', 'value': 1200},
      {'label': 'Feb', 'value': 1350},
      {'label': 'Mar', 'value': 1100},
      {'label': 'Apr', 'value': 1450},
      {'label': 'May', 'value': 1200},
      {'label': 'Jun', 'value': 950},
    ];

    final List<Map<String, dynamic>> categoryBreakdownData = [
      {'label': 'Food', 'value': 450, 'percentage': 30, 'color': 0xFF4CAF50},
      {
        'label': 'Transport',
        'value': 300,
        'percentage': 20,
        'color': 0xFF2196F3,
      },
      {
        'label': 'Shopping',
        'value': 225,
        'percentage': 15,
        'color': 0xFFFFC107,
      },
      {'label': 'Bills', 'value': 375, 'percentage': 25, 'color': 0xFFFF5722},
      {'label': 'Other', 'value': 150, 'percentage': 10, 'color': 0xFF9E9E9E},
    ];

    final List<Map<String, dynamic>> savingsOpportunities = [
      {'label': 'Coffee subscriptions', 'value': '22.99/mo'},
      {'label': 'Unused streaming services', 'value': '29.99/mo'},
      {'label': 'Dining out reduction (20%)', 'value': '120/mo'},
    ];

    // Enhance each insight with additional data
    final insightsMapped =
        insights.map((insight) {
          // Default insight data
          Map<String, dynamic> insightData = {
            'title': insight.title,
            'description': insight.description,
            'icon': insight.icon,
            'color': insight.color,
            'onDismiss': () => dashboardProvider.dismissInsight(insight),
            'onAction': () => dashboardProvider.handleInsightAction(insight),
            'actionLabel': insight.actionLabel,
          };

          // Add specific chart data based on insight type
          if (insight.title.contains('Spending') ||
              insight.title.contains('spending')) {
            insightData['chartType'] = 'line';
            insightData['chartData'] = spendingTrendData;
            insightData['learnMoreText'] =
                'Your spending has decreased by 21% compared to last month. Keep up the good work! Setting a monthly budget and tracking expenses regularly can help maintain this positive trend.';
          } else if (insight.title.contains('Categories') ||
              insight.title.contains('categories') ||
              insight.title.contains('breakdown')) {
            insightData['chartType'] = 'pie';
            insightData['chartData'] = categoryBreakdownData;
            insightData['learnMoreText'] =
                'Your largest spending category is Food at 30%. The average for users with similar income is 25%. Consider meal planning to bring this closer to the average.';
          } else if (insight.title.contains('Save') ||
              insight.title.contains('save') ||
              insight.title.contains('saving')) {
            insightData['chartType'] = 'list';
            insightData['chartData'] = savingsOpportunities;
            insightData['learnMoreText'] =
                'We identified potential savings of up to 172.98 per month based on your subscription services and recent spending patterns. Consider reviewing these areas for cost reduction.';
          }

          return insightData;
        }).toList();

    return AIInsightsCard(insights: insightsMapped);
  }

  @override
  Widget build(BuildContext context) {
    // Use Consumer to listen to dashboard provider changes
    return Consumer<DashboardProvider>(
      builder: (context, dashboardProvider, _) {
        return Scaffold(
          backgroundColor: Colors.transparent, // Ensure gradient shows through
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.gradientStart, AppColors.gradientEnd],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ),
                    child: _buildHeader(context),
                  ),
                  // Last updated timestamp
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Last updated: ${DateFormat('MMM d, y • h:mm a').format(dashboardProvider.lastUpdated)}',
                          style: TextStyle(
                            color: AppColors.textPrimary.withOpacity(0.6),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: () {
                            _refreshIndicatorKey.currentState?.show();
                          },
                          child: Icon(
                            Icons.refresh,
                            size: 16,
                            color: AppColors.textPrimary.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      key: _refreshIndicatorKey,
                      onRefresh: _loadDashboardData,
                      color: AppColors.accent,
                      backgroundColor: AppColors.cardBackground,
                      displacement: 20,
                      child:
                          dashboardProvider.isLoading
                              ? _buildLoadingState()
                              : SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize:
                                        MainAxisSize
                                            .min, // Ensure minimal height
                                    children: [
                                      const SizedBox(height: 10),
                                      // Top summary cards section
                                      SizedBox(
                                        width: double.infinity,
                                        child: _buildSummaryCards(context),
                                      ),
                                      const SizedBox(height: 24),
                                      _buildFinancialSummary(context),
                                      const SizedBox(height: 24),
                                      _buildExpenseChartPlaceholder(context),
                                      const SizedBox(height: 24),
                                      _buildRecentActivity(context),
                                      const SizedBox(height: 24),
                                      _buildQuickActions(context),
                                      const SizedBox(height: 24),
                                      _buildEnhancedAIInsights(context),
                                      // Add some bottom padding for better scrolling
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
