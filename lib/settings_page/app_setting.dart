import 'package:flutter/material.dart';

class AppSettings extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  String _currencySymbol = 'Rp';

  static const Map<String, double> _rupiahPerUnit = {
    'Rp': 1,
    '\$': 16500,
    '€': 19000,
    '¥': 110,
    'RM': 3900,
    'CN¥': 2300,
  };

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

  double convert(double amountInRupiah) {
    final rate = _rupiahPerUnit[_currencySymbol] ?? 1;
    return amountInRupiah / rate;
  }

  String formatMoney(double amountInRupiah) {
    final value = convert(amountInRupiah);
    final negative = value < 0;
    final decimals = (_currencySymbol == 'Rp' || _currencySymbol == '¥') ? 0 : 2;
    final parts = value.abs().toStringAsFixed(decimals).split('.');
    final digits = parts[0];
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
      buffer.write(digits[i]);
    }
    final fraction = decimals > 0 ? ',${parts[1]}' : '';
    return '${negative ? '-' : ''}$_currencySymbol$buffer$fraction';
  }
}