import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../constants/colors.dart';

class ExpenseChartCard extends StatefulWidget {
  final List<Map<String, dynamic>> chartData;
  final String selectedPeriod;
  final List<String> timePeriods;
  final Function(String) onPeriodChanged;
  final ValueChanged<String?> onSectionSelected;
  final String? selectedSection;

  const ExpenseChartCard({
    Key? key,
    required this.chartData,
    required this.selectedPeriod,
    required this.timePeriods,
    required this.onPeriodChanged,
    required this.onSectionSelected,
    this.selectedSection,
  }) : super(key: key);

  @override
  State<ExpenseChartCard> createState() => _ExpenseChartCardState();
}

class _ExpenseChartCardState extends State<ExpenseChartCard> {
  @override
  Widget build(BuildContext context) {
    final total = widget.chartData.fold<double>(
      0,
      (sum, item) => sum + (item['value'] as double),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
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
                _buildPieChart(),
                const SizedBox(width: 18),
                _buildLegend(total),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAccentBar(),
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
          _buildPeriodSelector(),
        ],
      ),
    );
  }

  Widget _buildAccentBar() {
    return const SizedBox(
      width: 5,
      height: 28,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: AppColors.accent,
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: DropdownButton<String>(
        value: widget.selectedPeriod,
        icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textPrimary, size: 18),
        elevation: 16,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
        underline: Container(height: 0),
        onChanged: (String? newValue) {
          if (newValue != null) {
            widget.onPeriodChanged(newValue);
          }
        },
        items: widget.timePeriods.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPieChart() {
    return SizedBox(
      height: 120,
      width: 120,
      child: PieChart(
        PieChartData(
          sections: widget.chartData.map((item) {
            final isSelected = widget.selectedSection == item['label'];
            return PieChartSectionData(
              color: item['color'] as Color,
              value: item['value'] as double,
              title: '',
              radius: isSelected ? 45 : 38, // Expand selected section
              showTitle: false,
              badgeWidget: isSelected
                  ? Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: item['color'] as Color,
                        size: 14,
                      ),
                    )
                  : null,
              badgePositionPercentageOffset: 1.1,
            );
          }).toList(),
          sectionsSpace: 2,
          centerSpaceRadius: 24,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              if (event is FlTapUpEvent && pieTouchResponse?.touchedSection != null) {
                final sectionIndex = pieTouchResponse!.touchedSection!.touchedSectionIndex;
                if (sectionIndex >= 0 && sectionIndex < widget.chartData.length) {
                  final String label = widget.chartData[sectionIndex]['label'] as String;
                  String? newSelection = label;
                  
                  if (widget.selectedSection == label) {
                    newSelection = null; // Deselect if already selected
                  }
                  
                  widget.onSectionSelected(newSelection);
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(double total) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.chartData.map((item) {
          final percent = ((item['value'] as double) / total * 100).toStringAsFixed(0);
          final isSelected = widget.selectedSection == item['label'];
          return InkWell(
            onTap: () {
              String? newSelection = item['label'] as String;
              if (widget.selectedSection == item['label']) {
                newSelection = null; // Deselect if already selected
              }
              widget.onSectionSelected(newSelection);
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
              decoration: BoxDecoration(
                color: isSelected ? (item['color'] as Color).withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: item['color'] as Color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 2)
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: (item['color'] as Color).withOpacity(0.3),
                                blurRadius: 4,
                                spreadRadius: 1,
                              )
                            ]
                          : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item['label'] as String,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$percent%',
                    style: TextStyle(
                      color: isSelected ? (item['color'] as Color) : AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
