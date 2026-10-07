import 'package:flutter/material.dart';
import '../../../models/transaction_model.dart';

const kategoriList = [
  'Gaji',
  'Makanan',
  'Transport',
  'Tagihan',
  'Belanja',
  'Lainnya',
];


Future<Transaction?> showTransactionForm(
  BuildContext context, {
  Transaction? initial,
}) {
  return showModalBottomSheet<Transaction>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => TransactionFormSheet(initial: initial),
  );
}

class TransactionFormSheet extends StatefulWidget {
  final Transaction? initial;

  const TransactionFormSheet({super.key, this.initial});

  @override
  State<TransactionFormSheet> createState() => _TransactionFormSheetState();
}

class _TransactionFormSheetState extends State<TransactionFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _amountCtrl;
  late String _category;
  late bool _isIncome;
  late DateTime _date;

  bool get _isEdit => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final tx = widget.initial;
    _titleCtrl = TextEditingController(text: tx?.title ?? '');
    _amountCtrl = TextEditingController(
      text: tx == null ? '' : tx.amount.toStringAsFixed(0),
    );
    _category = tx?.category ?? kategoriList.first;
    if (!kategoriList.contains(_category)) _category = 'Lainnya';
    _isIncome = tx?.isIncome ?? false;
    _date = tx?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final now = DateTime.now();
    final hasil = await showDatePicker(
      context: context,
      initialDate: _date.isAfter(now) ? now : _date,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
    );
    if (hasil != null) setState(() => _date = hasil);
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;
    final tx = Transaction(
      id: widget.initial?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      amount: double.parse(_amountCtrl.text.trim()),
      date: _date,
      category: _category,
      isIncome: _isIncome,
    );
    Navigator.pop(context, tx);
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isEdit ? 'Edit Transaksi' : 'Tambah Transaksi',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: false, label: Text('Keluar')),
                  ButtonSegment(value: true, label: Text('Masuk')),
                ],
                selected: {_isIncome},
                onSelectionChanged: (s) =>
                    setState(() => _isIncome = s.first),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nominal (Rp)',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final n = double.tryParse((v ?? '').trim());
                  if (n == null || n <= 0) return 'Masukkan nominal yang valid';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: kategoriList
                    .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                    .toList(),
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _pilihTanggal,
                icon: const Icon(Icons.calendar_today, size: 18),
                label: Text(_fmt(_date)),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _simpan,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}