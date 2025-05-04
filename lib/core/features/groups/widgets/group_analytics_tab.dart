import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../constants/colors.dart';
import '../models/group_analytics.dart';

class GroupAnalyticsTab extends StatefulWidget {
  final GroupAnalytics analytics;

  const GroupAnalyticsTab({
    required this.analytics,
    Key? key,
  }) : super(key: key);

  @override
  State<GroupAnalyticsTab> createState() => _GroupAnalyticsTabState();
}

class _GroupAnalyticsTabState extends State<GroupAnalyticsTab> {
  String _selectedTimeRange = 'Last 30 days';
  final List<String> _timeRanges = ['Last 7 days', 'Last 30 days', 'Last 3 months', 'Last year'];
  
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTimeRangeSelector(),
        const SizedBox(height: 24),
        _buildSpendingTrendsCard(),
        const SizedBox(height: 24),
        _buildCategoryBreakdownCard(),
        const SizedBox(height: 24),
        _buildMemberContributionsCard(),
        const SizedBox(height: 100), // Extra padding for bottom nav
      ],
    );
  }

  Widget _buildTimeRangeSelector() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _timeRanges.length,
        itemBuilder: (context, index) {
          final isSelected = _timeRanges[index] == _selectedTimeRange;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedTimeRange = _timeRanges[index];
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accentGradientMiddle : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  _timeRanges[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 14,
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
    return Card(
      color: AppColors.cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 3,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.accentGradientMiddle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Spending Trends',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.info_outline, size: 20, color: AppColors.textSecondary),
                  onPressed: () {
                    // Show info tooltip
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 50,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppColors.borderPrimary,
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
                          if (value.toInt() >= widget.analytics.spendingTrends.length || value.toInt() < 0) {
                            return const SizedBox();
                          }
                          final date = widget.analytics.spendingTrends[value.toInt()].date;
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
                  borderData: FlBorderData(
                    show: false,
                  ),
                  minX: 0,
                  maxX: widget.analytics.spendingTrends.length.toDouble() - 1,
                  minY: 0,
                  maxY: widget.analytics.spendingTrends
                      .map((e) => e.amount)
                      .reduce((a, b) => a > b ? a : b)
                      .ceilToDouble() + 50,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatCard(
                  'Total Spent',
                  '\$${widget.analytics.spendingTrends.map((e) => e.amount).reduce((a, b) => a + b).toStringAsFixed(2)}',
                  Icons.account_balance_wallet,
                ),
                const SizedBox(width: 16),
                _buildStatCard(
                  'Avg. per Day',
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

    return Card(
      color: AppColors.cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 3,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.accentGradientMiddle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Category Breakdown',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: widget.analytics.categoryBreakdown
                            .map((category) => PieChartSectionData(
                                  value: category.amount,
                                  color: category.color,
                                  title: '${((category.amount / total) * 100).toStringAsFixed(0)}%',
                                  radius: 80,
                                  titleStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: widget.analytics.categoryBreakdown
                        .map((category) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: category.color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      category.name,
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '\$${category.amount.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberContributionsCard() {
    return Card(
      color: AppColors.cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 3,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.accentGradientMiddle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Member Contributions',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...widget.analytics.memberContributions
                .map((member) => _buildMemberContributionItem(member))
                .toList(),
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
    final percentage = (member.totalContribution / totalGroupContribution) * 100;

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
                child: Icon(
                  Icons.person,
                  size: 16,
                  color: Colors.white,
                ),
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
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentGradientMiddle),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: AppColors.borderPrimary),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.background.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.accentGradientMiddle,
              size: 20,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
