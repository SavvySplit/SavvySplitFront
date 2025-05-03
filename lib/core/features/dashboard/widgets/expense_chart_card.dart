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
  final List<Map<String, dynamic>>? previousPeriodData; // For comparison

  const ExpenseChartCard({
    Key? key,
    required this.chartData,
    required this.selectedPeriod,
    required this.timePeriods,
    required this.onPeriodChanged,
    required this.onSectionSelected,
    this.selectedSection,
    this.previousPeriodData,
  }) : super(key: key);

  @override
  State<ExpenseChartCard> createState() => _ExpenseChartCardState();
}

class _ExpenseChartCardState extends State<ExpenseChartCard> with SingleTickerProviderStateMixin {
  bool _showComparison = false;
  bool _showDetailedView = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    _animationController.forward();
  }
  
  @override
  void didUpdateWidget(ExpenseChartCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.chartData != widget.chartData || 
        oldWidget.selectedPeriod != widget.selectedPeriod) {
      _animationController.reset();
      _animationController.forward();
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.withOpacity(0.15),
              width: 1.0,
            ),
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
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 4),
      child: Column(
        children: [
          Row(
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
              Row(
                children: [
                  _buildInteractionButtons(),
                  const SizedBox(width: 8),
                  _buildPeriodSelector(),
                ],
              ),
            ],
          ),
          if (_showDetailedView) ...[const SizedBox(height: 8), _buildDetailedViewToggle()],
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
      height: _showDetailedView ? 150 : 120,
      width: _showDetailedView ? 150 : 120,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return PieChart(
            PieChartData(
              sections: widget.chartData.map((item) {
                final isSelected = widget.selectedSection == item['label'];
                final double value = (item['value'] as double) * _animation.value;
                final double radius = isSelected ? 45 * _animation.value : 38 * _animation.value;
                
                return PieChartSectionData(
                  color: item['color'] as Color,
                  value: value,
                  title: _showDetailedView ? '${((value / (widget.chartData.fold<double>(0, (sum, item) => sum + (item['value'] as double) * _animation.value))) * 100).toStringAsFixed(0)}%' : '',
                  titleStyle: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  radius: _showDetailedView ? radius + 5 : radius, // Larger for detailed view
                  showTitle: _showDetailedView,
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
              centerSpaceRadius: _showDetailedView ? 30 : 24,
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
              centerSpaceColor: _showComparison && widget.previousPeriodData != null ? Colors.transparent : null,
            ),
            swapAnimationDuration: const Duration(milliseconds: 600),
          );
        },
      ),
    );
  }

  Widget _buildInteractionButtons() {
    return Row(
      children: [
        // Toggle comparison view
        if (widget.previousPeriodData != null)
          IconButton(
            icon: Icon(
              _showComparison ? Icons.compare_arrows : Icons.compare,
              color: _showComparison ? AppColors.accent : AppColors.textSecondary,
              size: 18,
            ),
            tooltip: _showComparison ? 'Hide comparison' : 'Compare with previous period',
            onPressed: () {
              setState(() {
                _showComparison = !_showComparison;
              });
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
          ),
        // Toggle detailed view
        IconButton(
          icon: Icon(
            _showDetailedView ? Icons.view_list : Icons.view_agenda,
            color: _showDetailedView ? AppColors.accent : AppColors.textSecondary,
            size: 18,
          ),
          tooltip: _showDetailedView ? 'Simple view' : 'Detailed view',
          onPressed: () {
            setState(() {
              _showDetailedView = !_showDetailedView;
            });
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
        ),
      ],
    );
  }

  Widget _buildDetailedViewToggle() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.selectedPeriod,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          Text(
            'Total: \$${widget.chartData.fold<double>(0, (sum, item) => sum + (item['value'] as double)).toStringAsFixed(2)}',
            style: const TextStyle(
              color: AppColors.accent,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
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
          
          // Find the corresponding item in previous data for comparison
          Map<String, dynamic>? previousItem;
          if (_showComparison && widget.previousPeriodData != null) {
            previousItem = widget.previousPeriodData!.firstWhere(
              (prev) => prev['label'] == item['label'],
              orElse: () => {'value': 0.0, 'label': item['label'], 'color': item['color']},
            );
          }
          
          // Calculate percentage change if comparison is enabled
          String changeText = '';
          IconData? changeIcon;
          Color? changeColor;
          
          if (_showComparison && previousItem != null) {
            final double prevValue = previousItem['value'] as double;
            final double currentValue = item['value'] as double;
            
            if (prevValue > 0) {
              final percentChange = ((currentValue - prevValue) / prevValue * 100);
              if (percentChange > 0) {
                changeText = '+${percentChange.toStringAsFixed(1)}%';
                changeIcon = Icons.arrow_upward;
                changeColor = Colors.red[400];
              } else if (percentChange < 0) {
                changeText = '${percentChange.toStringAsFixed(1)}%';
                changeIcon = Icons.arrow_downward;
                changeColor = Colors.green[400];
              }
            }
          }
          
          return InkWell(
            onTap: () {
              String? newSelection = item['label'] as String;
              if (widget.selectedSection == item['label']) {
                newSelection = null; // Deselect if already selected
              }
              widget.onSectionSelected(newSelection);
            },
            borderRadius: BorderRadius.circular(8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
              decoration: BoxDecoration(
                color: isSelected ? (item['color'] as Color).withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                      const Spacer(),
                      Text(
                        '$percent%',
                        style: TextStyle(
                          color: isSelected ? (item['color'] as Color) : AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      if (_showDetailedView) ...[                    
                        const SizedBox(width: 8),
                        Text(
                          '\$${(item['value'] as double).toStringAsFixed(0)}',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
                  ),
                  // Show comparison data if enabled
                  if (_showComparison && changeText.isNotEmpty) ...[                
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const SizedBox(width: 22), // Align with text above
                        Icon(
                          changeIcon,
                          size: 10,
                          color: changeColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          changeText,
                          style: TextStyle(
                            fontSize: 11,
                            color: changeColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (_showDetailedView) ...[                        
                          const Spacer(),
                          Text(
                            'vs. prev.',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],                
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
