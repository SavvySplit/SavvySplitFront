import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:savvysplit/core/features/dashboard/widgets/ai_insight_card.dart';
import '../../../../data/providers/auth_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        _buildSummaryCards(context),
                        const SizedBox(height: 32), // More space before chart
                        _buildExpenseChartPlaceholder(context),
                        const SizedBox(
                          height: 32,
                        ), // More space before activity
                        _buildRecentActivity(context),
                        const SizedBox(height: 32),
                        _buildQuickActions(context),
                        const SizedBox(height: 32),
                        _buildAIInsights(context),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Animation controller for the notification badge
  late AnimationController _animationController;
  int _notificationCount = 3;

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
          _notificationCount = 4;
          _animationController.forward(from: 0.0);
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) => Text(
                  'Welcome back, ${authProvider.firstName}!',
                  style: TextStyle(
                    color: AppColors.textPrimary.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
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
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$_notificationCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11.5,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.secondary.withOpacity(0.22),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Consumer<AuthProvider>(
                      builder: (context, authProvider, _) => CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.accentGradientEnd,
                        child: Text(
                          authProvider.firstInitial,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(BuildContext context) {
    // Mock data for the transaction list
    final transactions = [
      {
        'category': 'OTHERS',
        'title': 'Uber Ride',
        'date': '23/04/2025',
        'amount': -35.50,
        'icon': Icons.directions_car_outlined,
        'color': Colors.blue,
        'type': 'TRANSPORT',
      },
      {
        'category': 'BILLS',
        'title': 'Electric Bill',
        'date': '22/04/2025',
        'amount': -89.99,
        'icon': Icons.electrical_services_outlined,
        'color': Colors.blue,
        'type': 'BILLS',
      },
      {
        'category': 'SHOPPING',
        'title': 'Shopping Mall',
        'date': '21/04/2025',
        'amount': -120.00,
        'icon': Icons.shopping_bag_outlined,
        'color': Colors.teal,
        'type': 'SHOPPING',
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final isIncome =
            (transaction['type'] as String).toLowerCase() == 'income';
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {}, // for future interactivity
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 7,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: (transaction['color'] as Color).withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      transaction['icon'] as IconData,
                      color: transaction['color'] as Color,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction['title'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15.5,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          transaction['date'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    (isIncome ? '+' : '-') +
                        (transaction['amount'] as double).toStringAsFixed(2) +
                        ' USD',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15.5,
                      color:
                          isIncome
                              ? Colors.greenAccent.shade200
                              : Colors.redAccent.shade100,
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

  // Accent bar widget for section titles
  static const Widget AccentBar = SizedBox(
    width: 5,
    height: 28,
    child: DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        color: AppColors.accent,
      ),
    ),
  );

  Widget _buildSummaryCards(BuildContext context) {
    // Mock data for summary
    final summaries = [
      {
        'label': 'Balance',
        'value': '\$2,450.00',
        'icon': Icons.account_balance_wallet,
        'color': AppColors.accentGradientMiddle,
        'gradient': [
          AppColors.accentGradientStart,
          AppColors.accentGradientEnd,
        ],
      },
      {
        'label': 'Expenses',
        'value': '\$1,120.00',
        'icon': Icons.arrow_upward,
        'color': AppColors.error,
        'gradient': [AppColors.error, AppColors.cardBackground],
      },
      {
        'label': 'Income',
        'value': '\$00.00',
        'icon': Icons.arrow_downward,
        'color': AppColors.success,
        'gradient': [AppColors.success, AppColors.cardBackground],
      },
      {
        'label': 'Settlements',
        'value': '\$230.00',
        'icon': Icons.group,
        'color': AppColors.secondary,
        'gradient': [AppColors.secondary, AppColors.accentGradientEnd],
      },
    ];
    return SizedBox(
      height: 130, // increased height to prevent overflow
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 4), // reduced bottom padding
        scrollDirection: Axis.horizontal,
        itemCount: summaries.length,
        separatorBuilder: (context, index) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final item = summaries[index];
          return Container(
            width: 160,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: (item['gradient'] as List<Color>),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
              // Shadow removed as requested
              border: Border.all(
                color: AppColors.gradientEnd.withOpacity(0.13),
                width: 1.2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        item['label'] == 'Income'
                            ? Colors.white.withOpacity(
                              0.55,
                            ) // higher contrast for green card
                            : Colors.white.withOpacity(0.32),
                    // Icon shadow removed as requested
                  ),
                  padding: const EdgeInsets.all(7), // reduced padding
                  child: Icon(
                    item['icon'] as IconData,
                    color: item['color'] as Color,
                    size: 21, // reduced size
                  ),
                ),
                const SizedBox(height: 6), // reduced spacing
                Text(
                  item['value'] as String,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 19, // reduced size
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  item['label'] as String,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 11, // reduced size
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildExpenseChartPlaceholder(BuildContext context) {
    // Mock data for pie chart
    final chartData = [
      {'label': 'Food', 'value': 40.0, 'color': AppColors.error},
      {
        'label': 'Transport',
        'value': 25.0,
        'color': AppColors.categoryTransport,
      },
      {'label': 'Shopping', 'value': 20.0, 'color': AppColors.categoryShopping},
      {'label': 'Bills', 'value': 15.0, 'color': AppColors.categoryBills},
    ];
    final total = chartData.fold<double>(
      0,
      (sum, item) => sum + (item['value'] as double),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, top: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AccentBar,
              const SizedBox(width: 8),
              const Text(
                'Expenses Breakdown',
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
        Material(
          elevation: 4.0,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.surface, width: 1.2),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pie Chart
                SizedBox(
                  height: 120,
                  width: 120,
                  child: PieChart(
                    PieChartData(
                      sections:
                          chartData.map((item) {
                            return PieChartSectionData(
                              color: item['color'] as Color,
                              value: item['value'] as double,
                              title: '',
                              radius: 38,
                              showTitle: false,
                            );
                          }).toList(),
                      sectionsSpace: 2,
                      centerSpaceRadius: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                // Legend
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        chartData.map((item) {
                          final percent = ((item['value'] as double) /
                                  total *
                                  100)
                              .toStringAsFixed(0);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: item['color'] as Color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  item['label'] as String,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '$percent%',
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    // Mock data for recent activity
    final activities = [
      {
        'label': 'Coffee',
        'category': 'Food',
        'amount': '-4.50',
        'color': AppColors.error,
        'icon': Icons.local_cafe,
        'date': 'Today',
      },
      {
        'label': 'Uber',
        'category': 'Transport',
        'amount': '-12.00',
        'color': AppColors.categoryTransport,
        'icon': Icons.directions_car,
        'date': 'Yesterday',
      },
      {
        'label': 'Salary',
        'category': 'Income',
        'amount': '+1500.00',
        'color': AppColors.success,
        'icon': Icons.attach_money,
        'date': '2 days ago',
      },
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, top: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AccentBar,
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
        Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(8),
          color: AppColors.cardBackground,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.surface, width: 1.2),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              separatorBuilder: (context, index) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final item = activities[index];
                final isIncome =
                    (item['category'] as String).toLowerCase() == 'income';
                return Material(
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(14),
                  color: AppColors.cardBackground,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {}, // for future interactivity
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.07),
                            blurRadius: 7,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: (item['color'] as Color).withOpacity(0.18),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              item['icon'] as IconData,
                              color: item['color'] as Color,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['label'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15.5,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item['category'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.5,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                item['amount'] as String,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15.5,
                                  color:
                                      isIncome
                                          ? Colors.greenAccent.shade200
                                          : Colors.redAccent.shade100,
                                ),
                              ),
                              Text(
                                item['date'] as String,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Row(
            children: [
              AccentBar,
              const SizedBox(width: 8),
              const Text(
                'Quick Actions',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
        Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(8),
          color: AppColors.cardBackground,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.surface, width: 1.2),
            ),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  context,
                  Icons.add,
                  'Add Expense',
                  AppColors.accentGradientStart,
                  AppColors.accentGradientEnd,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Navigate to Add Expense')),
                    );
                  },
                ),
                _buildActionButton(
                  context,
                  Icons.attach_money,
                  'Add Income',
                  AppColors.success,
                  AppColors.success,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Navigate to Add Income')),
                    );
                  },
                ),
                _buildActionButton(
                  context,
                  Icons.group,
                  'Split Bill',
                  AppColors.secondary,
                  AppColors.accentGradientEnd,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Navigate to Split Bill')),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAIInsights(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AccentBar,
            const SizedBox(width: 8),
            const Text(
              'AI Insights',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 18,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
        Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(8),
          color: AppColors.cardBackground,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.surface, width: 1.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 16),
                AIInsightCard(
                  title: 'Unusual Spending',
                  description:
                      'Your restaurant spending is 40% higher than last month',
                  icon: Icons.warning_amber_outlined,
                  color: AppColors.error,
                ),
                SizedBox(height: 12),
                AIInsightCard(
                  title: 'Savings Opportunity',
                  description:
                      'You could save \$200 by optimizing your subscriptions',
                  icon: Icons.savings_outlined,
                  color: AppColors.success,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    Color colorStart,
    Color colorEnd,
    VoidCallback onTap,
  ) {
    final ValueNotifier<double> scaleNotifier = ValueNotifier(1.0);

    return ValueListenableBuilder<double>(
      valueListenable: scaleNotifier,
      builder: (context, scale, child) {
        return GestureDetector(
          onTapDown: (_) => scaleNotifier.value = 0.93,
          onTapUp: (_) {
            scaleNotifier.value = 1.0;
            onTap();
          },
          onTapCancel: () => scaleNotifier.value = 1.0,
          child: Transform.scale(
            scale: scale,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 90,
                maxWidth: 110,
                minHeight: 92,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorStart, colorEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.18),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorStart.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: onTap,
                    splashColor: Colors.white.withOpacity(0.10),
                    highlightColor: Colors.white.withOpacity(0.05),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 8,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, size: 28, color: Colors.white),
                          const SizedBox(height: 8),
                          Text(
                            label,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
