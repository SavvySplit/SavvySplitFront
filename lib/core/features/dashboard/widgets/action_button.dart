import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color colorStart;
  final Color colorEnd;
  final VoidCallback onTap;

  const ActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.colorStart,
    required this.colorEnd,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Scale animation for tap effect
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
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorStart, colorEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.15),
                  width: 1.0,
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min, // Keep column as small as possible
                children: [
                  // Icon with circular background
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Label text
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                      letterSpacing: 0.2,
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
}
