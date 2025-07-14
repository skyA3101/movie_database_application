import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  factory ThemeProvider.instance() {
    return _internal;
  }

  ThemeProvider.internal();

  static final ThemeProvider _internal = ThemeProvider.internal();

  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
