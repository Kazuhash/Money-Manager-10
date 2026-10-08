import 'package:flutter/material.dart';
import '../models/category_model.dart';

class CategoryTile extends StatelessWidget {
  final Category category;
  final bool selected;
  final VoidCallback onTap;

  const CategoryTile({
    super.key,
    required this.category,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: category.color.withValues(alpha: 0.18),
        child: Icon(category.icon, color: category.color, size: 20),
      ),
      title: Text(category.name),
      trailing: selected
          ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
          : null,
      onTap: onTap,
    );
  }
}
