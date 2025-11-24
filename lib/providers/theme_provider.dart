import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  static String _themeKey = 'theme_key';

  ThemeProvider() {
    _loadTheme();
  }

  void _loadTheme() async{
    final prefs = await SharedPreferences.getInstance();
    final darkMode = prefs.getBool(_themeKey) ?? false;
    _themeMode = darkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void toggleTheme(bool isDarkModeOn) async {
    _themeMode = isDarkModeOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_themeKey, isDarkModeOn);
  }
}