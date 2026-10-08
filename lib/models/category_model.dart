import 'package:flutter/material.dart';

enum CategoryType { expense, income }

const List<IconData> kCategoryIcons = [
  Icons.restaurant,
  Icons.directions_car,
  Icons.shopping_bag,
  Icons.payments,
  Icons.receipt_long,
  Icons.movie,
  Icons.local_hospital,
  Icons.school,
  Icons.home,
  Icons.card_giftcard,
  Icons.savings,
  Icons.more_horiz,
];

const List<Color> kCategoryColors = [
  Color(0xFFF08080),
  Color(0xFFF4A261),
  Color(0xFFE9C46A),
  Color(0xFF7CC896),
  Color(0xFF4C98AF),
  Color(0xFF3B82F6),
  Color(0xFF8B5CF6),
  Color(0xFFEC4899),
];

class Category {
  final String id;
  final String name;
  final int iconIndex;
  final int colorValue;
  final CategoryType type;

  const Category({
    required this.id,
    required this.name,
    required this.iconIndex,
    required this.colorValue,
    required this.type,
  });

  IconData get icon => kCategoryIcons[iconIndex % kCategoryIcons.length];
  Color get color => Color(colorValue);
  bool get isIncome => type == CategoryType.income;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'iconIndex': iconIndex,
        'colorValue': colorValue,
        'type': type.name,
      };

  factory Category.fromMap(Map<String, dynamic> m) => Category(
        id: m['id'] as String,
        name: m['name'] as String,
        iconIndex: m['iconIndex'] as int,
        colorValue: m['colorValue'] as int,
        type: CategoryType.values.byName(m['type'] as String),
      );
}
