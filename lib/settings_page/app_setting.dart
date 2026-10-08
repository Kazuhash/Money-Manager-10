import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  static const _darkModeKey = 'isDarkMode';

  AppSettings({required SharedPreferences preferences})
    : _preferences = preferences,
      _themeMode = (preferences.getBool(_darkModeKey) ?? false)
          ? ThemeMode.dark
          : ThemeMode.light;

  final SharedPreferences _preferences;
  ThemeMode _themeMode;
  String _currencySymbol = 'Rp';

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;
  String get currencySymbol => _currencySymbol;

  Future<void> setDark(bool value) async {
    if (value == isDark) return;
    final saved = await _preferences.setBool(_darkModeKey, value);
    if (!saved) {
      throw StateError('Could not save dark mode preference.');
    }
    _themeMode = value ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setCurrency(String symbol) {
    _currencySymbol = symbol;
    notifyListeners();
  }

  String formatMoney(double amount) {
    final negative = amount < 0;
    final digits = amount.abs().round().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
      buffer.write(digits[i]);
    }
    return '${negative ? '-' : ''}$_currencySymbol$buffer';
  }
}
