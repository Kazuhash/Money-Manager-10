import 'package:flutter/material.dart';

class CategoryModel {
  String name;
  IconData icon;
  CategoryModel({required this.name, required this.icon});
}

class KelolaKategoriSection extends StatefulWidget {
  final List<CategoryModel> initialCategories;

  const KelolaKategoriSection({super.key, required this.initialCategories});

  @override
  State<KelolaKategoriSection> createState() => _KelolaKategoriSectionState();
}

class _KelolaKategoriSectionState extends State<KelolaKategoriSection> {
  late List<CategoryModel> _categories;

  @override
  void initState() {
    super.initState();
    _categories = List.from(widget.initialCategories);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._categories.map((cat) => ListTile(
              leading: Icon(cat.icon),
              title: Text(cat.name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () => _showCategoryDialog(existing: cat),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                    onPressed: () {
                      setState(() => _categories.remove(cat));
                    },
                  ),
                ],
              ),
            )),
        ListTile(
          leading: const Icon(Icons.add, color: Colors.blue),
          title: const Text('Tambah Kategori', style: TextStyle(color: Colors.blue)),
          onTap: () => _showCategoryDialog(),
        ),
      ],
    );
  }

  void _showCategoryDialog({CategoryModel? existing}) {
    final controller = TextEditingController(text: existing?.name ?? '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existing == null ? 'Tambah Kategori' : 'Edit Kategori'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nama kategori'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isEmpty) return;
              setState(() {
                if (existing != null) {
                  existing.name = controller.text.trim();
                } else {
                  _categories.add(
                      CategoryModel(name: controller.text.trim(), icon: Icons.label));
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}