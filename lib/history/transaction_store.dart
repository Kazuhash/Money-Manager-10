import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_model.dart';

class TransactionStore {
  static const _key = 'transactions_v1';

  static Future<List<Transaction>?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => _fromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      return null;
    }
  }

  static Future<void> save(List<Transaction> data) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(data.map(_toMap).toList());
    await prefs.setString(_key, raw);
  }

  static Map<String, dynamic> _toMap(Transaction t) => {
        'id': t.id,
        'title': t.title,
        'amount': t.amount,
        'date': t.date.toIso8601String(),
        'category': t.category,
        'isIncome': t.isIncome,
      };

  static Transaction _fromMap(Map<String, dynamic> m) => Transaction(
        id: m['id'] as String,
        title: m['title'] as String,
        amount: (m['amount'] as num).toDouble(),
        date: DateTime.parse(m['date'] as String),
        category: m['category'] as String,
        isIncome: m['isIncome'] as bool,
      );
}