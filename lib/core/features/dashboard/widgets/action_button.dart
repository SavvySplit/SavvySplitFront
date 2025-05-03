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
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 80,  // Reduced from 90
                maxWidth: 95,  // Reduced from 110
                minHeight: 92,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorStart, colorEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.18),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorStart.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: onTap,
                    splashColor: Colors.white.withOpacity(0.10),
                    highlightColor: Colors.white.withOpacity(0.05),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 8,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, size: 28, color: Colors.white),
                          const SizedBox(height: 8),
                          Text(
                            label,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
