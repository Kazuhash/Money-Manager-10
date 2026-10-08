import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category_model.dart';
import '../provider/category_provider.dart';
import 'add_category_dialogue.dart';
import 'category_tile_widget.dart';

class CategorySelectionPage extends StatefulWidget {
  final CategoryType type;
  final Category? selected;

  const CategorySelectionPage({super.key, required this.type, this.selected});

  @override
  State<CategorySelectionPage> createState() => _CategorySelectionPageState();
}

class _CategorySelectionPageState extends State<CategorySelectionPage> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _addNew() async {
    final created = await showAddCategoryDialog(
      context,
      type: widget.type,
      initialName: _query.trim(),
    );
    if (created != null && mounted) Navigator.pop(context, created);
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = widget.type == CategoryType.income;
    final categories = context
        .watch<CategoryProvider>()
        .byType(widget.type, query: _query);

    return Scaffold(
      appBar: AppBar(
        title: Text(isIncome ? 'Kategori Pemasukan' : 'Kategori Pengeluaran'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Cari kategori',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                for (final c in categories)
                  CategoryTile(
                    category: c,
                    selected: widget.selected?.id == c.id,
                    onTap: () => Navigator.pop(context, c),
                  ),
                if (categories.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: Text('Kategori tidak ditemukan')),
                  ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.12),
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  title: Text(
                    _query.trim().isEmpty
                        ? 'Tambah kategori baru'
                        : 'Tambah "${_query.trim()}"',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  onTap: _addNew,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
