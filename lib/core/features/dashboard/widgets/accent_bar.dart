import 'package:flutter/material.dart';
import '../../../constants/colors.dart';

/// A simple vertical accent bar for section headers or decoration.
class AccentBar extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  final double borderRadius;

  const AccentBar({
    Key? key,
    this.height = 24,
    this.width = 4,
    this.color = AppColors.primary,
    this.borderRadius = 6,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
