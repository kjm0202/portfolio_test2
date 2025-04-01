import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  final String key = 'theme_mode';
  late SharedPreferences prefs;
  late bool _isDarkMode;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _isDarkMode = false;
    _loadFromPrefs();
  }

  toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _isDarkMode = prefs.getBool(key) ?? false;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    prefs.setBool(key, _isDarkMode);
  }
}