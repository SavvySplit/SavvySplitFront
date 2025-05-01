import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themePreferenceKey = 'theme_preference';
  
  bool _isDarkMode = true; // Default to dark mode
  
  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  
  ThemeProvider() {
    _loadThemePreference();
  }
  
  // Load theme preference from shared preferences
  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Default to dark mode if preference not found
      _isDarkMode = prefs.getBool(_themePreferenceKey) ?? true;
      notifyListeners();
    } catch (e) {
      // In case of error, default to dark mode
      _isDarkMode = true;
      print('Error loading theme preference: $e');
    }
  }
  
  // Toggle between light and dark mode
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themePreferenceKey, _isDarkMode);
    } catch (e) {
      print('Error saving theme preference: $e');
    }
  }
  
  // Set specific theme mode
  Future<void> setDarkMode(bool isDark) async {
    if (_isDarkMode != isDark) {
      _isDarkMode = isDark;
      notifyListeners();
      
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_themePreferenceKey, _isDarkMode);
      } catch (e) {
        print('Error saving theme preference: $e');
      }
    }
  }
}
