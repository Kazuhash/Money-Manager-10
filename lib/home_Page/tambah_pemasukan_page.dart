import 'package:flutter/material.dart';
import 'form_transaksi.dart';
import 'transaksi.dart';

class TambahPemasukanPage extends StatelessWidget {
  const TambahPemasukanPage({super.key});

  static const green = Color(0xFF7CC896);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pemasukan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: FormTransaksi(
          tipe: TipeTransaksi.pemasukan,
          warna: green,
          kategori: const ['Gaji', 'Uang saku', 'Bonus', 'Hadiah', 'Lainnya'],
          onSimpan: (t) => Navigator.pop(context, t),
        ),
      ),
    );
  }
}