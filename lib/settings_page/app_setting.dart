import 'package:flutter/material.dart';

class AppSettings extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  String _currencySymbol = 'Rp';

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;
  String get currencySymbol => _currencySymbol;

  void setDark(bool value) {
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