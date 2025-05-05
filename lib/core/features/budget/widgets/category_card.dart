import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final double spent;
  final double budget;
  final double percentage;

  const CategoryCard({
    Key? key,
    required this.name,
    required this.spent,
    required this.budget,
    required this.percentage,
  }) : super(key: key);

  Color _getStatusColor() {
    if (percentage >= 1) return Colors.red;
    if (percentage > 0.8) return Colors.orange;
    return Colors.green;
  }

  Widget _buildWarningBanner() {
    final isOverBudget = (budget - spent) < 0;
    final remaining = budget - spent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isOverBudget
                ? Colors.red.withOpacity(0.2)
                : Colors.orange.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Icon(
                isOverBudget ? Icons.warning_amber_rounded : Icons.info_outline,
                color: isOverBudget ? Colors.red[300] : Colors.orange[300],
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isOverBudget
                      ? 'Budget exceeded!'
                      : 'Approaching budget limit',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isOverBudget
              ? 'Overspent by \$${remaining.abs().toStringAsFixed(2)}'
              : '\$${remaining.toStringAsFixed(2)} remaining',
          style: TextStyle(
            color: isOverBudget ? Colors.red[300] : Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final remaining = budget - spent;
    final isOverBudget = remaining < 0;
    final isNearLimit = !isOverBudget && percentage > 0.8;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isOverBudget
            ? BorderSide(color: Colors.red.withOpacity(0.5), width: 1)
            : isNearLimit
                ? BorderSide(color: Colors.orange.withOpacity(0.5), width: 1)
                : BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      color: Colors.white.withOpacity(0.05),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getStatusColor().withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${(percentage * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: _getStatusColor(),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (isOverBudget || isNearLimit) ...[
              _buildWarningBanner(),
              const SizedBox(height: 6),
            ] else
              const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage > 1 ? 1 : percentage,
                backgroundColor: Colors.grey.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(_getStatusColor()),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Spent',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '\$${spent.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      isOverBudget ? 'Overspent' : 'Remaining',
                      style: TextStyle(
                        color: isOverBudget ? Colors.red[300] : Colors.white54,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '\$${remaining.abs().toStringAsFixed(2)}',
                      style: TextStyle(
                        color: isOverBudget ? Colors.red[300] : Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
