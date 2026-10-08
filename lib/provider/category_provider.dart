import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category_model.dart';

class CategoryProvider extends ChangeNotifier {
  static const _key = 'categories_v1';

  static const List<Category> _defaults = [
    Category(id: 'e-makanan', name: 'Makanan', iconIndex: 0, colorValue: 0xFFF4A261, type: CategoryType.expense),
    Category(id: 'e-transport', name: 'Transportasi', iconIndex: 1, colorValue: 0xFF3B82F6, type: CategoryType.expense),
    Category(id: 'e-belanja', name: 'Belanja', iconIndex: 2, colorValue: 0xFFEC4899, type: CategoryType.expense),
    Category(id: 'e-tagihan', name: 'Tagihan', iconIndex: 4, colorValue: 0xFF8B5CF6, type: CategoryType.expense),
    Category(id: 'e-hiburan', name: 'Hiburan', iconIndex: 5, colorValue: 0xFFE9C46A, type: CategoryType.expense),
    Category(id: 'e-kesehatan', name: 'Kesehatan', iconIndex: 6, colorValue: 0xFFF08080, type: CategoryType.expense),
    Category(id: 'e-lainnya', name: 'Lainnya', iconIndex: 11, colorValue: 0xFF9CA3AF, type: CategoryType.expense),
    Category(id: 'i-gaji', name: 'Gaji', iconIndex: 3, colorValue: 0xFF7CC896, type: CategoryType.income),
    Category(id: 'i-bonus', name: 'Bonus', iconIndex: 10, colorValue: 0xFF4C98AF, type: CategoryType.income),
    Category(id: 'i-hadiah', name: 'Hadiah', iconIndex: 9, colorValue: 0xFFEC4899, type: CategoryType.income),
    Category(id: 'i-lainnya', name: 'Lainnya', iconIndex: 11, colorValue: 0xFF9CA3AF, type: CategoryType.income),
  ];

  List<Category> _categories = List.of(_defaults);

  CategoryProvider() {
    _load();
  }

  List<Category> get categories => List.unmodifiable(_categories);

  /// Categories of one type, optionally filtered by a search [query].
  List<Category> byType(CategoryType type, {String query = ''}) {
    final q = query.trim().toLowerCase();
    return _categories
        .where((c) =>
            c.type == type && (q.isEmpty || c.name.toLowerCase().contains(q)))
        .toList();
  }

  bool exists(String name, CategoryType type) {
    final n = name.trim().toLowerCase();
    return _categories.any((c) => c.type == type && c.name.toLowerCase() == n);
  }

  /// Adds a category. Returns null if the name is empty or already used.
  Category? addCategory({
    required String name,
    required int iconIndex,
    required int colorValue,
    required CategoryType type,
  }) {
    final trimmed = name.trim();
    if (trimmed.isEmpty || exists(trimmed, type)) return null;
    final category = Category(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: trimmed,
      iconIndex: iconIndex,
      colorValue: colorValue,
      type: type,
    );
    _categories = [..._categories, category];
    notifyListeners();
    _save();
    return category;
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null) return;
      final list = jsonDecode(raw) as List;
      _categories = list
          .map((e) => Category.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
      notifyListeners();
    } catch (_) {
      // Keep the default categories if saved data is unreadable.
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(_categories.map((c) => c.toMap()).toList()),
    );
  }
}
