import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTimeRange = 'Last 30 days';
  bool _isLoading = true;

  final List<String> _timeRanges = [
    'Last 7 days',
    'Last 30 days',
    'Last 3 months',
    'This year',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAnalyticsData();
  }

  Future<void> _loadAnalyticsData() async {
    setState(() => _isLoading = true);
    // Simulate network request
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBreakdown(BuildContext context) {
    final categories = [
      {'name': 'Food', 'percentage': 35, 'color': AppColors.error},
      {
        'name': 'Transport',
        'percentage': 25,
        'color': AppColors.categoryTransport,
      },
      {
        'name': 'Shopping',
        'percentage': 20,
        'color': AppColors.categoryShopping,
      },
      {'name': 'Bills', 'percentage': 15, 'color': AppColors.categoryBills},
      {'name': 'Others', 'percentage': 5, 'color': Colors.grey},
    ];

    return _buildCard(
      title: 'Category Breakdown',
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                sections:
                    categories.map((category) {
                      return PieChartSectionData(
                        color: category['color'] as Color,
                        value: (category['percentage'] as int).toDouble(),
                        title: '${category['percentage']}%',
                        radius: 60,
                        titleStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children:
                categories.map((category) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: category['color'] as Color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        category['name'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withValues(alpha: 0.95),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              _buildTimeRangeSelector(),
              const SizedBox(height: 8),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadAnalyticsData,
                  color: theme.colorScheme.primary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSummaryCards(),
                        const SizedBox(height: 20),
                        _buildExpenseChart(context),
                        const SizedBox(height: 20),
                        _buildCategoryBreakdown(context),
                        const SizedBox(height: 20),
                        _buildMonthlyComparison(context),
                        const SizedBox(height: 20),
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

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Analytics',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Your financial insights',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.filter_list_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              tooltip: 'Filter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    final theme = Theme.of(context);

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: _timeRanges.length,
        itemBuilder: (context, index) {
          final range = _timeRanges[index];
          final isSelected = _selectedTimeRange == range;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(range),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedTimeRange = range;
                  _loadAnalyticsData();
                });
              },
              backgroundColor: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.5),
              selectedColor: theme.colorScheme.primaryContainer,
              labelStyle: theme.textTheme.labelLarge?.copyWith(
                color:
                    isSelected
                        ? theme.colorScheme.onPrimaryContainer
                        : theme.colorScheme.onSurfaceVariant,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              side: BorderSide(
                color:
                    isSelected
                        ? theme.colorScheme.primary.withValues(alpha: 0.3)
                        : theme.colorScheme.outlineVariant,
                width: 1,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards() {
    if (_isLoading) {
      return _buildSummaryCardsShimmer();
    }

    final theme = Theme.of(context);

    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildSummaryCard(
            title: 'Total Spent',
            amount: 1245.67,
            change: -5.2,
            icon: Icons.arrow_upward_rounded,
            color: theme.colorScheme.error,
          ),
          const SizedBox(width: 12),
          _buildSummaryCard(
            title: 'Income',
            amount: 3200.00,
            change: 12.4,
            icon: Icons.arrow_downward_rounded,
            color: theme.colorScheme.tertiary,
          ),
          const SizedBox(width: 12),
          _buildSummaryCard(
            title: 'Savings',
            amount: 954.33,
            change: 7.8,
            icon: Icons.savings_rounded,
            color: theme.colorScheme.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double amount,
    required double change,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final isPositive = change >= 0;
    final formatter = NumberFormat.currency(symbol: '\$');

    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                formatter.format(amount),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${change.toStringAsFixed(1)}%',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCardsShimmer() {
    final theme = Theme.of(context);
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(3, (index) {
          return Padding(
            padding: EdgeInsets.only(right: index < 2 ? 12 : 0),
            child: Shimmer.fromColors(
              baseColor: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.1,
              ),
              highlightColor: theme.colorScheme.surface,
              child: Container(
                width: 160,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildExpenseChart(BuildContext context) {
    return _buildCard(
      title: 'Monthly Expenses',
      child: SizedBox(
        height: 220,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const style = TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    );
                    String text;
                    switch (value.toInt()) {
                      case 0:
                        text = 'Jan';
                        break;
                      case 2:
                        text = 'Mar';
                        break;
                      case 4:
                        text = 'May';
                        break;
                      case 6:
                        text = 'Jul';
                        break;
                      case 8:
                        text = 'Sep';
                        break;
                      case 10:
                        text = 'Nov';
                        break;
                      default:
                        return Container();
                    }
                    return Text(text, style: style);
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 3),
                  FlSpot(1, 2),
                  FlSpot(2, 5),
                  FlSpot(3, 3.1),
                  FlSpot(4, 4),
                  FlSpot(5, 3),
                  FlSpot(6, 4),
                  FlSpot(7, 4.5),
                  FlSpot(8, 5),
                  FlSpot(9, 4.7),
                  FlSpot(10, 6),
                  FlSpot(11, 5.5),
                ],
                isCurved: true,
                color: AppColors.accentGradientEnd,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: AppColors.accentGradientEnd.withOpacity(0.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlyComparison(BuildContext context) {
    return _buildCard(
      title: 'Monthly Comparison',
      child: SizedBox(
        height: 200,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 1000,
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const style = TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    );
                    String text;
                    switch (value.toInt()) {
                      case 0:
                        text = 'Jan';
                        break;
                      case 1:
                        text = 'Feb';
                        break;
                      case 2:
                        text = 'Mar';
                        break;
                      case 3:
                        text = 'Apr';
                        break;
                      case 4:
                        text = 'May';
                        break;
                      default:
                        return Container();
                    }
                    return Text(text, style: style);
                  },
                  reservedSize: 30,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value == 0) return Container();
                    return Text(
                      '\$${value.toInt()}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    );
                  },
                  reservedSize: 40,
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(
                    toY: 800,
                    color: AppColors.accentGradientStart,
                    width: 20,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                ],
              ),
              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(
                    toY: 650,
                    color: AppColors.accentGradientStart,
                    width: 20,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                ],
              ),
              BarChartGroupData(
                x: 2,
                barRods: [
                  BarChartRodData(
                    toY: 900,
                    color: AppColors.accentGradientStart,
                    width: 20,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                ],
              ),
              BarChartGroupData(
                x: 3,
                barRods: [
                  BarChartRodData(
                    toY: 750,
                    color: AppColors.accentGradientStart,
                    width: 20,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                ],
              ),
              BarChartGroupData(
                x: 4,
                barRods: [
                  BarChartRodData(
                    toY: 850,
                    color: AppColors.accentGradientStart,
                    width: 20,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSavingsProgress(BuildContext context) {
    return _buildCard(
      title: 'Savings Progress',
      child: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Monthly Target',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const Text(
                '\$500 / \$1,000',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0.5,
              minHeight: 12,
              backgroundColor: Colors.grey.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.success,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Annual Target',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const Text(
                '\$3,500 / \$10,000',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0.35,
              minHeight: 12,
              backgroundColor: Colors.grey.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.success,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
