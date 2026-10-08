import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../category_page/category_selection_page.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../models/transaction_repo.dart';
import '../settings_page/app_setting.dart';

class TransactionFormWidget extends StatefulWidget {
  final bool initialIsIncome;

  const TransactionFormWidget({super.key, this.initialIsIncome = false});

  @override
  State<TransactionFormWidget> createState() => _TransactionFormWidgetState();
}

class _TransactionFormWidgetState extends State<TransactionFormWidget> {
  static const _green = Color(0xFF7CC896);
  static const _red = Color(0xFFF08080);

  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  late bool _isIncome = widget.initialIsIncome;
  Category? _category;
  DateTime _date = DateTime.now();

  Color get _accent => _isIncome ? _green : _red;
  CategoryType get _type =>
      _isIncome ? CategoryType.income : CategoryType.expense;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _pickCategory(FormFieldState<Category> field) async {
    final picked = await Navigator.push<Category>(
      context,
      MaterialPageRoute(
        builder: (_) => CategorySelectionPage(type: _type, selected: _category),
      ),
    );
    if (picked == null || !mounted) return;
    setState(() => _category = picked);
    field.didChange(picked);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 1, 12, 31),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountCtrl.text.replaceAll('.', ''));
    final category = _category!;
    final note = _noteCtrl.text.trim();
    final tx = Transaction(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: note.isEmpty ? category.name : '${category.name} - $note',
      amount: amount,
      date: _date,
      category: category.name,
      isIncome: _isIncome,
    );

    final repo = context.read<TransactionRepository>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    repo.add(tx);
    navigator.pop(tx);
    messenger.showSnackBar(
      const SnackBar(content: Text('Transaksi disimpan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currency = context.read<AppSettings>().currencySymbol;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<bool>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: false, label: Text('Pengeluaran')),
                ButtonSegment(value: true, label: Text('Pemasukan')),
              ],
              selected: {_isIncome},
              onSelectionChanged: (s) => setState(() {
                _isIncome = s.first;
                // Categories are separate for income and expense.
                _category = null;
              }),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _amountCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [_ThousandsFormatter()],
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              labelText: 'Jumlah',
              prefixText: '$currency ',
              border: const OutlineInputBorder(),
            ),
            validator: (v) {
              final n = int.tryParse((v ?? '').replaceAll('.', ''));
              if (n == null || n <= 0) return 'Isi jumlah dengan benar';
              return null;
            },
          ),
          const SizedBox(height: 16),
          FormField<Category>(
            key: ValueKey(_type),
            validator: (_) => _category == null ? 'Pilih kategori' : null,
            builder: (field) => InkWell(
              onTap: () => _pickCategory(field),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  border: const OutlineInputBorder(),
                  errorText: field.errorText,
                  suffixIcon: const Icon(Icons.chevron_right),
                ),
                child: _category == null
                    ? Text(
                        'Pilih kategori',
                        style: TextStyle(color: Theme.of(context).hintColor),
                      )
                    : Row(
                        children: [
                          Icon(_category!.icon, color: _category!.color, size: 20),
                          const SizedBox(width: 12),
                          Text(_category!.name),
                        ],
                      ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: _pickDate,
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Tanggal',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today, size: 20),
              ),
              child: Text(_formatDate(_date)),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _noteCtrl,
            decoration: const InputDecoration(
              labelText: 'Catatan (opsional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: _accent),
              onPressed: _save,
              child: const Text('Simpan'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text
        .replaceAll(RegExp(r'\D'), '')
        .replaceFirst(RegExp(r'^0+'), '');
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
      buffer.write(digits[i]);
    }
    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
