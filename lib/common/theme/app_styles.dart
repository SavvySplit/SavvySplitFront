import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyles {
  static TextStyle titleLarge(BuildContext context) => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).textTheme.titleLarge?.color,
  );

  static TextStyle titleMedium(BuildContext context) => GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).textTheme.titleMedium?.color,
  );

  static TextStyle titleSmall(BuildContext context) => GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).textTheme.titleSmall?.color,
  );

  static TextStyle bodyLarge(BuildContext context) => GoogleFonts.roboto(
    fontSize: 16,
    color: Theme.of(context).textTheme.bodyLarge?.color,
  );

  static TextStyle bodyMedium(BuildContext context) => GoogleFonts.roboto(
    fontSize: 14,
    color: Theme.of(context).textTheme.bodyMedium?.color,
  );

  static TextStyle bodySmall(BuildContext context) => GoogleFonts.roboto(
    fontSize: 12,
    color: Theme.of(context).textTheme.bodySmall?.color,
  );
}
