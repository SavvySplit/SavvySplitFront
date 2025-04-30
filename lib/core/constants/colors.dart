import 'package:flutter/material.dart';

class AppColors {
  // Darker color scheme
  static const Color primary = Color(0xFF091C31); // Very dark blue primary
  static const Color secondary = Color(0xFF0E7BBF); // Darker blue accent
  static const Color accent = Color(0xFF1E88CA); // Medium blue accent
  static const Color background = Color(
    0xFF051525,
  ); // Very dark blue background
  static const Color surface = Color(0xFF071E34); // Darker surface
  static const Color cardBackground = Color(
    0xFF081A2C,
  ); // Darker card background
  static const Color textPrimary = Color(0xFFFFFFFF); // White text
  static const Color textSecondary = Color(0xFFA0B0C1); // Light blue-gray text
  static const Color success = Color(0xFF4CAF50); // Green for success states
  static const Color error = Color(
    0xFFE53935,
  ); // Red for error states (negative amounts)
  static const Color borderPrimary = Color(
    0xFF1E3A5F,
  ); // Medium blue for borders

  // Additional colors from the screenshot
  static const Color categoryBills = Color(
    0xFF0E9BB6,
  ); // Teal for bills category
  static const Color categoryTransport = Color(
    0xFF127FA0,
  ); // Blue for transport category
  static const Color categoryShopping = Color(
    0xFF1AA1C0,
  ); // Light blue for shopping category
  static const Color insightBackground = Color(
    0xFF102C4C,
  ); // Background for insights

  // Gradients
  static const Color gradientStart = Color(
    0xFF041220,
  ); // Very dark blue gradient start
  static const Color gradientEnd = Color(0xFF091C31); // Dark blue gradient end

  // Button gradients
  static const Color accentGradientStart = Color(
    0xFF0C64A0,
  ); // Rich dark blue button gradient start
  static const Color accentGradientMiddle = Color(
    0xFF0E7BBF,
  ); // Medium blue button gradient middle
  static const Color accentGradientEnd = Color(
    0xFF6EC6FF,
  ); // Lighter blue button gradient end

  // Extra button gradient for more dramatic effect
  static const Color buttonGradientStart = Color(
    0xFF064273,
  ); // Very deep blue button gradient start
  static const Color buttonGradientEnd = Color(
    0xFF34B4FF,
  ); // Vibrant light blue button gradient end
}
