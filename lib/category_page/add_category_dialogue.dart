import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category_model.dart';
import '../provider/category_provider.dart';

Future<Category?> showAddCategoryDialog(
  BuildContext context, {
  required CategoryType type,
  String initialName = '',
}) {
  return showDialog<Category>(
    context: context,
    builder: (_) => _AddCategoryDialog(type: type, initialName: initialName),
  );
}

class _AddCategoryDialog extends StatefulWidget {
  final CategoryType type;
  final String initialName;

  const _AddCategoryDialog({required this.type, required this.initialName});

  @override
  State<_AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<_AddCategoryDialog> {
  late final TextEditingController _nameCtrl;
  int _iconIndex = 0;
  int _colorIndex = 0;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName);
    _colorIndex = widget.type == CategoryType.income ? 3 : 0;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Nama kategori wajib diisi');
      return;
    }
    final created = context.read<CategoryProvider>().addCategory(
          name: name,
          iconIndex: _iconIndex,
          colorValue: kCategoryColors[_colorIndex].toARGB32(),
          type: widget.type,
        );
    if (created == null) {
      setState(() => _error = 'Kategori "$name" sudah ada');
      return;
    }
    Navigator.pop(context, created);
  }

  @override
  Widget build(BuildContext context) {
    final color = kCategoryColors[_colorIndex];
    return AlertDialog(
      title: const Text('Kategori baru'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameCtrl,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Nama kategori',
                errorText: _error,
              ),
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 16),
            const Text('Ikon'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < kCategoryIcons.length; i++)
                  GestureDetector(
                    onTap: () => setState(() => _iconIndex = i),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: i == _iconIndex
                          ? color
                          : color.withValues(alpha: 0.12),
                      child: Icon(
                        kCategoryIcons[i],
                        size: 18,
                        color: i == _iconIndex ? Colors.white : color,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Warna'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < kCategoryColors.length; i++)
                  GestureDetector(
                    onTap: () => setState(() => _colorIndex = i),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: kCategoryColors[i],
                      child: i == _colorIndex
                          ? const Icon(Icons.check, size: 16, color: Colors.white)
                          : null,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Simpan')),
      ],
    );
  }
}
