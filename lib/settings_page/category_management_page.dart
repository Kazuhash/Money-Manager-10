import 'package:flutter/material.dart';
import 'kelola_kategori_widget.dart';
import 'app_theme.dart';

class CategoryManagementPage extends StatelessWidget {
  const CategoryManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Kategori'),
        backgroundColor: const Color(0xFF81C995),
        foregroundColor: Colors.white,
        centerTitle: true,
        flexibleSpace: const HologramAppBarBackground(),
      ),
      body: SingleChildScrollView(
        child: KelolaKategoriSection(
          initialCategories: [
            CategoryModel(name: 'Makanan', icon: Icons.restaurant),
            CategoryModel(name: 'Transportasi', icon: Icons.directions_car),
            CategoryModel(name: 'Gaji', icon: Icons.payments),
            CategoryModel(name: 'Lainnya', icon: Icons.more_horiz),
          ],
        ),
      ),
    );
  }
}