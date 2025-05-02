import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../constants/colors.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                        const SizedBox(height: 16),
                        _buildExpenseChart(context),
                        const SizedBox(height: 24),
                        _buildCategoryBreakdown(context),
                        const SizedBox(height: 24),
                        _buildMonthlyComparison(context),
                        const SizedBox(height: 24),
                        _buildSavingsProgress(context),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analytics',
              style:
                  Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                  ) ??
                  const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Your financial insights',
              style: TextStyle(
                color: AppColors.textPrimary.withOpacity(0.7),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.date_range, color: Colors.white),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.secondary.withOpacity(0.22),
            shape: const CircleBorder(),
          ),
        ),
      ],
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

  Widget _buildCard({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Container(
                width: 5,
                height: 24,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.surface, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }
}
