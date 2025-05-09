import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_styles.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      primarySwatch: AppColors.primarySwatch,
      brightness: Brightness.light,
      textTheme: TextTheme(
        // Display styles
        displayLarge: AppStyles.displayLarge(context),
        
        // Headline styles
        headlineLarge: AppStyles.headlineLarge(context),
        headlineMedium: AppStyles.headlineMedium(context),
        
        // Title styles
        titleLarge: AppStyles.titleLarge(context),
        titleMedium: AppStyles.titleMedium(context),
        titleSmall: AppStyles.titleSmall(context),
        
        // Body styles
        bodyLarge: AppStyles.bodyLarge(context),
        bodyMedium: AppStyles.bodyMedium(context),
        bodySmall: AppStyles.bodySmall(context),
        
        // Label styles
        labelLarge: AppStyles.labelLarge(context),
        labelMedium: AppStyles.labelMedium(context),
        labelSmall: AppStyles.labelSmall(context),
      ),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      // Primary Colors
      primarySwatch: AppColors.primarySwatch,
      primaryColor: AppColors.primaryColor,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryColor,
        secondary: AppColors.accentColor,
        surface: AppColors.cardColor,
        error: AppColors.errorColor,
      ),

      // Background Colors
      scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
      canvasColor: AppColors.backgroundColor,
      cardColor: AppColors.cardColor,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.appBarColor,
        foregroundColor: AppColors.textColor,
        elevation: 0,
      ),

      // Brightness
      brightness: Brightness.dark,

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonColor,
          foregroundColor: AppColors.buttonTextColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // Text Colors
      textTheme: TextTheme(
        // Display styles
        displayLarge: AppStyles.displayLarge(context).copyWith(color: AppColors.textColor),

        // Headline styles
        headlineLarge: AppStyles.headlineLarge(context).copyWith(color: AppColors.textColor),
        headlineMedium: AppStyles.headlineMedium(context).copyWith(color: AppColors.textColor),
        
        // Title styles
        titleLarge: AppStyles.titleLarge(context).copyWith(color: AppColors.textColor),
        titleMedium: AppStyles.titleMedium(context).copyWith(color: AppColors.textColor),
        titleSmall: AppStyles.titleSmall(context).copyWith(color: AppColors.secondaryTextColor),
        
        // Body styles
        bodyLarge: AppStyles.bodyLarge(context).copyWith(color: AppColors.textColor),
        bodyMedium: AppStyles.bodyMedium(context).copyWith(color: AppColors.secondaryTextColor),
        bodySmall: AppStyles.bodySmall(context).copyWith(color: AppColors.secondaryTextColor),
        
        // Label styles
        labelLarge: AppStyles.labelLarge(context).copyWith(color: AppColors.textColor),
        labelMedium: AppStyles.labelMedium(context).copyWith(color: AppColors.secondaryTextColor),
        labelSmall: AppStyles.labelSmall(context).copyWith(color: AppColors.secondaryTextColor),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardColor.withOpacity(0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.dividerColor, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.dividerColor, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.accentColor, width: 2.0),
        ),
        labelStyle: TextStyle(
          color: AppColors.secondaryTextColor,
          fontSize: 16,
        ),
      ),

      // Divider Color
      dividerColor: AppColors.dividerColor,

      // Card Theme
      cardTheme: CardTheme(
        color: AppColors.cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dialogTheme: DialogThemeData(backgroundColor: AppColors.cardColor),
    );
  }
}
