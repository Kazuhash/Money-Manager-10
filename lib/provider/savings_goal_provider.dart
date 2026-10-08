import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/savings_goal.dart';

class SavingsGoalProvider extends ChangeNotifier {
  static const _storageKey = 'savings_goal_v1';

  SavingsGoalProvider({required SharedPreferences preferences})
    : _preferences = preferences {
    final raw = preferences.getString(_storageKey);
    if (raw != null) {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Saved savings goal must be an object.');
      }
      _goal = SavingsGoal.fromJson(decoded);
    }
  }

  final SharedPreferences _preferences;
  SavingsGoal? _goal;

  SavingsGoal? get goal => _goal;

  Future<void> saveGoal({
    required String name,
    required double targetAmount,
  }) async {
    final updated = SavingsGoal(
      name: name.trim(),
      targetAmount: targetAmount,
      savedAmount: _goal?.savedAmount ?? 0,
    );
    await _save(updated);
  }

  Future<void> addContribution(double amount) async {
    final current = _goal;
    if (current == null) {
      throw StateError('Create a savings goal before adding contributions.');
    }
    if (!amount.isFinite || amount <= 0) {
      throw ArgumentError.value(amount, 'amount', 'Must be greater than zero.');
    }
    await _save(current.copyWith(savedAmount: current.savedAmount + amount));
  }

  Future<void> _save(SavingsGoal updated) async {
    final encoded = jsonEncode(updated.toJson());
    final saved = await _preferences.setString(_storageKey, encoded);
    if (!saved) {
      throw StateError('Could not save savings goal.');
    }
    _goal = updated;
    notifyListeners();
  }
}
