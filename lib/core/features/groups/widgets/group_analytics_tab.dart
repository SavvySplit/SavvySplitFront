import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../constants/colors.dart';
import '../models/group_analytics.dart';

class GroupAnalyticsTab extends StatefulWidget {
  final GroupAnalytics analytics;

  const GroupAnalyticsTab({required this.analytics, Key? key})
    : super(key: key);

  @override
  State<GroupAnalyticsTab> createState() => _GroupAnalyticsTabState();
}

class _GroupAnalyticsTabState extends State<GroupAnalyticsTab> {
  String _selectedTimeRange = 'Last 30 days';
  final List<String> _timeRanges = [
    'Last 7 days',
    'Last 30 days',
    'Last 3 months',
    'Last year',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildTimeRangeSelector(),
          const SizedBox(height: 24),
          _buildSpendingTrendsCard(),
          const SizedBox(height: 16),
          _buildCategoryBreakdownCard(),
          const SizedBox(height: 16),
          _buildMemberContributionsCard(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   'Group Analytics',
        //   style: TextStyle(
        //     color: Colors.white,
        //     fontSize: 24,
        //     fontWeight: FontWeight.bold,
        //     letterSpacing: 0.5,
        //   ),
        // ),
        // const SizedBox(height: 4),
        Text(
          'Track and analyze group spending patterns',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildTimeRangeSelector() {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _timeRanges.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final isSelected = _timeRanges[index] == _selectedTimeRange;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedTimeRange = _timeRanges[index];
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                gradient:
                    isSelected
                        ? const LinearGradient(
                          colors: [
                            AppColors.accentGradientStart,
                            AppColors.accentGradientEnd,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                        : null,
                color: isSelected ? null : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: AppColors.accentGradientEnd.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                        : null,
              ),
              child: Center(
                child: Text(
                  _timeRanges[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSpendingTrendsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.accentGradientStart,
                        AppColors.accentGradientEnd,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.trending_up_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Spending Trends',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _selectedTimeRange,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(color: Colors.white10, height: 24),
            const SizedBox(height: 24),
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 50,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.white.withOpacity(0.05),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >=
                                  widget.analytics.spendingTrends.length ||
                              value.toInt() < 0) {
                            return const SizedBox();
                          }
                          final date =
                              widget
                                  .analytics
                                  .spendingTrends[value.toInt()]
                                  .date;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              DateFormat('MM/dd').format(date),
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 50,
                        reservedSize: 40,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: widget.analytics.spendingTrends.length.toDouble() - 1,
                  minY: 0,
                  maxY:
                      widget.analytics.spendingTrends
                          .map((e) => e.amount)
                          .reduce((a, b) => a > b ? a : b)
                          .ceilToDouble() +
                      50,
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        widget.analytics.spendingTrends.length,
                        (index) => FlSpot(
                          index.toDouble(),
                          widget.analytics.spendingTrends[index].amount,
                        ),
                      ),
                      isCurved: true,
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.accentGradientStart,
                          AppColors.accentGradientEnd,
                        ],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: AppColors.accentGradientEnd,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.accentGradientEnd.withOpacity(0.3),
                            AppColors.accentGradientStart.withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatCard(
                  'Total Spent',
                  '\$${widget.analytics.spendingTrends.map((e) => e.amount).reduce((a, b) => a + b).toStringAsFixed(2)}',
                  Icons.account_balance_wallet,
                ),
                _buildStatCard(
                  'Avg/Day',
                  '\$${(widget.analytics.spendingTrends.map((e) => e.amount).reduce((a, b) => a + b) / widget.analytics.spendingTrends.length).toStringAsFixed(2)}',
                  Icons.trending_up,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBreakdownCard() {
    final total = widget.analytics.categoryBreakdown
        .map((e) => e.amount)
        .reduce((a, b) => a + b);
    final numberFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.accentGradientStart,
                        AppColors.accentGradientEnd,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.category_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Category Breakdown',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(color: Colors.white10, height: 24),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 400;
                  return isWide 
                    ? _buildWideCategoryLayout(total, numberFormat)
                    : _buildNarrowCategoryLayout(total, numberFormat);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMemberContributionItem(MemberContribution member) {
    // Calculate the percentage of total contribution
    final totalGroupContribution = widget.analytics.memberContributions
        .map((e) => e.totalContribution)
        .reduce((a, b) => a + b);
    final percentage =
        (member.totalContribution / totalGroupContribution) * 100;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.accentGradientMiddle,
                child: Icon(Icons.person, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.memberName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Contributed \$${member.totalContribution.toStringAsFixed(2)} (${percentage.toStringAsFixed(0)}%)',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.expand_more,
                  color: AppColors.textSecondary,
                ),
                onPressed: () {
                  // Toggle expanded view
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: AppColors.borderPrimary,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.accentGradientMiddle,
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: AppColors.borderPrimary),
        ],
      ),
    );
  }

  Widget _buildMemberContributionsCard() {
    if (widget.analytics.memberContributions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'No member contributions to show',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.accentGradientStart,
                        AppColors.accentGradientEnd,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.people_alt_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Member Contributions',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10, height: 1),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: widget.analytics.memberContributions
                  .map((member) => _buildMemberContributionItem(member))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWideCategoryLayout(double total, NumberFormat numberFormat) {
    return SizedBox(
      height: 220,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 24,
                    sections: widget.analytics.categoryBreakdown.map((category) {
                      final percentage = (category.amount / total) * 100;
                      return PieChartSectionData(
                        value: category.amount,
                        color: category.color,
                        title: percentage >= 5 ? '${percentage.toStringAsFixed(0)}%' : '',
                        radius: 50,
                        titleStyle: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: _buildCategoryLegend(total, numberFormat),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNarrowCategoryLayout(double total, NumberFormat numberFormat) {
    return SizedBox(
      height: 400,
      child: Column(
        children: [
          SizedBox(
            height: 160,
            child: PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 30,
                sections: widget.analytics.categoryBreakdown.map((category) {
                  final percentage = (category.amount / total) * 100;
                  return PieChartSectionData(
                    value: category.amount,
                    color: category.color,
                    title: percentage >= 5 ? '${percentage.toStringAsFixed(0)}%' : '',
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildCategoryLegend(total, numberFormat),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryLegend(double total, NumberFormat numberFormat) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      shrinkWrap: true,
      itemCount: widget.analytics.categoryBreakdown.length,
      itemBuilder: (context, index) {
        final category = widget.analytics.categoryBreakdown[index];
        final percentage = (category.amount / total) * 100;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: category.color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: category.color.withOpacity(0.5),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  category.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                numberFormat.format(category.amount),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Flexible(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.background.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.accentGradientMiddle, size: 18),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
