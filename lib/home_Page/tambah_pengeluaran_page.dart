import 'package:flutter/material.dart';
import 'form_transaksi.dart';
import 'transaksi.dart';

class TambahPengeluaranPage extends StatelessWidget {
  const TambahPengeluaranPage({super.key});

  static const red = Color(0xFFF08080);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pengeluaran'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: FormTransaksi(
          tipe: TipeTransaksi.pengeluaran,
          warna: red,
          kategori: const [
            'Makanan',
            'Transportasi',
            'Belanja',
            'Hiburan',
            'Kesehatan',
            'Lainnya',
          ],
          onSimpan: (t) => Navigator.pop(context, t),
        ),
      ),
    );
  }
}