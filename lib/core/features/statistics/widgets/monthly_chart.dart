import 'package:flutter/material.dart';

class MonthlyChart extends StatelessWidget {
  const MonthlyChart({super.key});

  @override
  Widget build(BuildContext context) {
    // Fake data for demonstration
    final months = ['Nov', 'Dec', 'Jan', 'Feb', 'Mar', 'Apr'];
    final amounts = [1400.0, 1800.0, 2300.0, 1700.0, 2200.0, 2600.0];
    final maxAmount = 4000.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 200,
          width: double.infinity,
          padding: const EdgeInsets.only(top: 24, right: 12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  // Y-axis labels
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 28,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$4.0k',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '\$3.2k',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '\$2.4k',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '\$1.6k',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '\$0.8k',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Horizontal grid lines
                  Positioned(
                    left: 36,
                    right: 0,
                    top: 0,
                    bottom: 28,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        5,
                        (index) => Container(
                          height: 1,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ),
                  
                  // Bars
                  Positioned(
                    left: 36,
                    right: 0,
                    bottom: 28,
                    top: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(
                        months.length,
                        (index) {
                          final height = (amounts[index] / maxAmount) * 
                              (constraints.maxHeight - 28);
                          
                          return Container(
                            width: 16,
                            height: height,
                            decoration: BoxDecoration(
                              color: Colors.tealAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  
                  // X-axis labels (months)
                  Positioned(
                    left: 36,
                    right: 0,
                    bottom: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: months
                          .map(
                            (month) => Text(
                              month,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 12,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
