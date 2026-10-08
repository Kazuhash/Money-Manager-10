import 'package:flutter/material.dart';
import 'transaksi.dart';

class FormTransaksi extends StatefulWidget {
  final TipeTransaksi tipe;
  final Color warna;
  final List<String> kategori;
  final void Function(Transaksi) onSimpan;

  const FormTransaksi({
    super.key,
    required this.tipe,
    required this.warna,
    required this.kategori,
    required this.onSimpan,
  });

  @override
  State<FormTransaksi> createState() => _FormTransaksiState();
}

class _FormTransaksiState extends State<FormTransaksi> {
  final _catatan = TextEditingController();
  final _jumlah = TextEditingController();
  late String _kategori = widget.kategori.first;

  @override
  void dispose() {
    _catatan.dispose();
    _jumlah.dispose();
    super.dispose();
  }

  void _simpan() {
    final jumlah = double.tryParse(_jumlah.text.replaceAll('.', ''));
    if (jumlah == null || jumlah <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi jumlah dengan benar')),
      );
      return;
    }
    final catatan = _catatan.text.trim();
    widget.onSimpan(
      Transaksi(
        judul: catatan.isEmpty ? _kategori : '$_kategori - $catatan',
        jumlah: jumlah,
        tipe: widget.tipe,
        tanggal: DateTime.now(),
        kategori: _kategori,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          initialValue: _kategori,
          decoration: const InputDecoration(labelText: 'Kategori'),
          items: widget.kategori
              .map((k) => DropdownMenuItem(value: k, child: Text(k)))
              .toList(),
          onChanged: (v) => setState(() => _kategori = v!),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _jumlah,
          keyboardType: TextInputType.number,
          decoration:
              const InputDecoration(labelText: 'Jumlah', prefixText: 'Rp '),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _catatan,
          decoration: const InputDecoration(labelText: 'Catatan (opsional)'),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            style: FilledButton.styleFrom(backgroundColor: widget.warna),
            onPressed: _simpan,
            child: const Text('Simpan'),
          ),
        ),
      ],
    );
  }
}