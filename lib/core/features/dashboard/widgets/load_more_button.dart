import 'package:flutter/material.dart';
import '../../../constants/colors.dart';

class LoadMoreButton extends StatelessWidget {
  final bool isShowingAll;
  final VoidCallback onPressed;

  const LoadMoreButton({
    Key? key,
    required this.isShowingAll,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        isShowingAll ? 'Show Less' : 'Show All',
        style: const TextStyle(
          color: AppColors.accent,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
