import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyles {
  // Display styles - for large screen titles
  static TextStyle displayLarge(BuildContext context) => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.2,
    height: 1.3,
    color: Theme.of(context).textTheme.displayLarge?.color,
  );

  // Headline styles - for section headers
  static TextStyle headlineLarge(BuildContext context) => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.15,
    height: 1.3,
    color: Theme.of(context).textTheme.headlineLarge?.color,
  );

  static TextStyle headlineMedium(BuildContext context) => GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
    height: 1.4,
    color: Theme.of(context).textTheme.headlineMedium?.color,
  );

  // Title styles - for card headers and important UI elements
  static TextStyle titleLarge(BuildContext context) => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
    height: 1.4,
    color: Theme.of(context).textTheme.titleLarge?.color,
  );

  static TextStyle titleMedium(BuildContext context) => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.5,
    color: Theme.of(context).textTheme.titleMedium?.color,
  );

  static TextStyle titleSmall(BuildContext context) => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.5,
    color: Theme.of(context).textTheme.titleSmall?.color,
  );

  // Body styles - for main content
  static TextStyle bodyLarge(BuildContext context) => GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
    color: Theme.of(context).textTheme.bodyLarge?.color,
  );

  static TextStyle bodyMedium(BuildContext context) => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
    color: Theme.of(context).textTheme.bodyMedium?.color,
  );

  static TextStyle bodySmall(BuildContext context) => GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.5,
    color: Theme.of(context).textTheme.bodySmall?.color,
  );

  // Label styles - for buttons, tags, and other UI components
  static TextStyle labelLarge(BuildContext context) => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.4,
    color: Theme.of(context).textTheme.labelLarge?.color,
  );

  static TextStyle labelMedium(BuildContext context) => GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.4,
    color: Theme.of(context).textTheme.labelMedium?.color,
  );

  static TextStyle labelSmall(BuildContext context) => GoogleFonts.roboto(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.4,
    color: Theme.of(context).textTheme.labelSmall?.color,
  );
}
