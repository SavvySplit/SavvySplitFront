import 'package:flutter/material.dart';
import '../../core/constants/colors.dart' as app_theme;

class AppColors {
  // Create a custom material color swatch based on our theme
  static MaterialColor primarySwatch = createMaterialColor(
    app_theme.AppColors.primary,
  );

  // Primary colors
  static const Color primaryColor = app_theme.AppColors.primary;
  static const Color accentColor = app_theme.AppColors.accent;
  static const Color backgroundColor = app_theme.AppColors.background;

  // Text colors
  static const Color textColor = app_theme.AppColors.textPrimary;
  static const Color secondaryTextColor = app_theme.AppColors.textSecondary;

  // UI element colors
  static final Color dividerColor = app_theme.AppColors.borderPrimary;
  static const Color cardColor = app_theme.AppColors.surface;
  static const Color scaffoldBackgroundColor = app_theme.AppColors.background;
  static const Color appBarColor = app_theme.AppColors.primary;

  // Functional colors
  static const Color errorColor = app_theme.AppColors.error;
  static const Color successColor = app_theme.AppColors.success;
  static const Color warningColor = Colors.orangeAccent;

  // Button colors
  static const Color buttonColor = app_theme.AppColors.secondary;
  static const Color buttonTextColor = Colors.white;

  // Gradient colors
  static const Color gradientStart = app_theme.AppColors.gradientStart;
  static const Color gradientEnd = app_theme.AppColors.gradientEnd;

  // Helper method to create MaterialColor from a Color
  static MaterialColor createMaterialColor(Color color) {
    List<double> strengths = <double>[.05, .1, .2, .3, .4, .5, .6, .7, .8, .9];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.toARGB32(), swatch);
  }
}
