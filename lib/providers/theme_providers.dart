import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProviders extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  static const String themePrefKey = 'theme_mode';

  ThemeMode get themeMode => _themeMode;

  ThemeProviders() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final savedThemeMode = prefs.getString(themePrefKey);
    if (savedThemeMode == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  Future<void> toggleThemeMode() async {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(themePrefKey, _themeMode == ThemeMode.dark ? 'dark' : 'light');

    notifyListeners();
  }

  bool get isDarkMode => _themeMode == ThemeMode.dark;
}