import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import 'package:fl_chart/fl_chart.dart';

class InteractiveAIInsightCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback? onDismiss;
  final VoidCallback? onAction;
  final String? actionLabel;
  final Map<String, dynamic>? detailedData;
  final String? chartType;
  final List<Map<String, dynamic>>? chartData;
  final String? learnMoreText;

  const InteractiveAIInsightCard({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.onDismiss,
    this.onAction,
    this.actionLabel,
    this.detailedData,
    this.chartType,
    this.chartData,
    this.learnMoreText,
  }) : super(key: key);

  @override
  State<InteractiveAIInsightCard> createState() => _InteractiveAIInsightCardState();
}

class _InteractiveAIInsightCardState extends State<InteractiveAIInsightCard> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  bool? _wasHelpful;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotationAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.5).animate(_expandAnimation);
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _provideFeedback(bool isHelpful) {
    setState(() {
      _wasHelpful = isHelpful;
    });
    // Here you would typically send this feedback to your backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Thank you for your feedback!'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.accent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('insight_${widget.title}'),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red.shade300,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        if (widget.onDismiss != null) {
          widget.onDismiss!();
        }
        return true;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: widget.color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: widget.color.withOpacity(0.3),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with title, icon, and expand button
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    widget.icon,
                    color: widget.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.description,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: _toggleExpand,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: RotationTransition(
                      turns: _rotationAnimation,
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: widget.color,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Expandable details section
            SizeTransition(
              sizeFactor: _expandAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.surface),
                  const SizedBox(height: 12),
                  
                  // Detailed data visualization
                  if (widget.chartData != null && widget.chartData!.isNotEmpty)
                    _buildChartVisualization(),
                    
                  // Learn more section
                  if (widget.learnMoreText != null)
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                color: widget.color,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'Learn More',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.learnMoreText!,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                  // Feedback section
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Was this insight helpful?',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildFeedbackButton(
                              isPositive: true, 
                              isSelected: _wasHelpful == true
                            ),
                            const SizedBox(width: 8),
                            _buildFeedbackButton(
                              isPositive: false, 
                              isSelected: _wasHelpful == false
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Action button
            if (widget.onAction != null && widget.actionLabel != null)
              Padding(
                padding: const EdgeInsets.only(top: 12.0, left: 4.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: widget.onAction,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      backgroundColor: widget.color.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      widget.actionLabel!,
                      style: TextStyle(
                        color: widget.color,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackButton({required bool isPositive, required bool isSelected}) {
    return InkWell(
      onTap: _wasHelpful == null || _wasHelpful != isPositive 
        ? () => _provideFeedback(isPositive) 
        : null,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected 
            ? (isPositive ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2))
            : AppColors.surface.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
              ? (isPositive ? Colors.green.withOpacity(0.5) : Colors.red.withOpacity(0.5))
              : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isPositive ? Icons.thumb_up_outlined : Icons.thumb_down_outlined,
              color: isSelected 
                ? (isPositive ? Colors.green : Colors.red)
                : AppColors.textSecondary,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              isPositive ? 'Yes' : 'No',
              style: TextStyle(
                color: isSelected 
                  ? (isPositive ? Colors.green : Colors.red)
                  : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildChartVisualization() {
    // Choose chart type based on the chartType property
    // For this example, I'm implementing a line chart for spending trends
    // and a pie chart for spending breakdown
    if (widget.chartType == 'line') {
      return Container(
        height: 200,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value >= 0 && value < widget.chartData!.length) {
                      final label = widget.chartData![value.toInt()]['label'];
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          label,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                  reservedSize: 28,
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(
                  widget.chartData!.length,
                  (index) => FlSpot(
                    index.toDouble(),
                    widget.chartData![index]['value'].toDouble(),
                  ),
                ),
                isCurved: true,
                color: widget.color,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: widget.color.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (widget.chartType == 'pie') {
      return Container(
        height: 200,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 30,
                  sections: List.generate(
                    widget.chartData!.length,
                    (index) => PieChartSectionData(
                      color: Color(widget.chartData![index]['color']),
                      value: widget.chartData![index]['value'].toDouble(),
                      title: '${widget.chartData![index]['percentage']}%',
                      radius: 50,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  widget.chartData!.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Color(widget.chartData![index]['color']),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.chartData![index]['label'],
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Default: Just show the data as text if chart type is not specified
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.chartData!.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item['label'],
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    item['value'].toString(),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    }
  }
}
