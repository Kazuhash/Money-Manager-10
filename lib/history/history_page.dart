import 'package:flutter/material.dart';
import '../../models/transaction_model.dart';
import 'date.dart';
import 'transaction_store.dart';
import 'widgets/date_header.dart';
import 'widgets/empty_history.dart';
import 'widgets/filters.dart';
import 'widgets/tile.dart';
import 'widgets/summary_card.dart';
import 'widgets/search.dart';
import 'widgets/date_range.dart';
import 'widgets/transaction_form.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  static const _filters = ['Semua', 'Masuk', 'Keluar'];

  List<Transaction> _transactions = [];
  bool _loading = true;

  String _selectedFilter = 'Semua';
  String _query = '';
  DateTimeRange? _range;

  @override
  void initState() {
    super.initState();
    _muat();
  }

  Future<void> _muat() async {
    final saved = await TransactionStore.load();
    if (!mounted) return;
    setState(() {
      _transactions = saved ?? _seed();
      _loading = false;
    });
  }

  void _simpanData() => TransactionStore.save(_transactions);

  List<Transaction> _seed() => [
        Transaction(
          id: '1',
          title: 'Gaji Bulanan',
          amount: 5000000,
          date: DateTime.now(),
          category: 'Gaji',
          isIncome: true,
        ),
        Transaction(
          id: '2',
          title: 'Makan Siang Nasi Padang',
          amount: 25000,
          date: DateTime.now(),
          category: 'Makanan',
          isIncome: false,
        ),
        Transaction(
          id: '3',
          title: 'Beli Bensin',
          amount: 50000,
          date: DateTime.now(),
          category: 'Transport',
          isIncome: false,
        ),
        Transaction(
          id: '4',
          title: 'Token Listrik Kost',
          amount: 100000,
          date: DateTime.now().subtract(const Duration(days: 1)),
          category: 'Tagihan',
          isIncome: false,
        ),
        Transaction(
          id: '5',
          title: 'Transfer dari mom',
          amount: 500000,
          date: DateTime.now().subtract(const Duration(days: 1)),
          category: 'Lainnya',
          isIncome: true,
        ),
        Transaction(
          id: '6',
          title: 'Belanja monthly Alfamart',
          amount: 150000,
          date: DateTime.now().subtract(const Duration(days: 3)),
          category: 'Belanja',
          isIncome: false,
        ),
      ];

  List<Transaction> get _visibleTransactions {
    final q = _query.trim().toLowerCase();
    final hasil = _transactions.where((tx) {
      if (_selectedFilter == 'Masuk' && !tx.isIncome) return false;
      if (_selectedFilter == 'Keluar' && tx.isIncome) return false;
      if (q.isNotEmpty && !tx.title.toLowerCase().contains(q)) return false;
      if (_range != null) {
        final hari = DateTime(tx.date.year, tx.date.month, tx.date.day);
        if (hari.isBefore(_range!.start) || hari.isAfter(_range!.end)) {
          return false;
        }
      }
      return true;
    }).toList();
    hasil.sort((a, b) => b.date.compareTo(a.date));
    return hasil;
  }

  Future<void> _pilihRentang() async {
    final now = DateTime.now();
    final hasil = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      initialDateRange: _range,
    );
    if (hasil != null) setState(() => _range = hasil);
  }

  Future<void> _tambah() async {
    final baru = await showTransactionForm(context);
    if (baru == null) return;
    setState(() => _transactions.add(baru));
    _simpanData();
    _showSnack('${baru.title} berhasil ditambahkan');
  }

  Future<void> _edit(Transaction lama) async {
    final hasil = await showTransactionForm(context, initial: lama);
    if (hasil == null) return;
    final index = _transactions.indexWhere((item) => item.id == lama.id);
    if (index == -1) return;
    setState(() => _transactions[index] = hasil);
    _simpanData();
    _showSnack('${hasil.title} berhasil diperbarui');
  }

  void _hapus(Transaction tx) {
    final index = _transactions.indexWhere((item) => item.id == tx.id);
    setState(() => _transactions.removeAt(index));
    _simpanData();

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${tx.title} berhasil dihapus'),
          action: SnackBarAction(
            label: 'Urungkan',
            onPressed: () {
              setState(() => _transactions.insert(index, tx));
              _simpanData();
            },
          ),
        ),
      );
  }

  void _showSnack(String pesan) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(pesan)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final data = _visibleTransactions;
    final totalMasuk = data
        .where((t) => t.isIncome)
        .fold<double>(0, (s, t) => s + t.amount);
    final totalKeluar = data
        .where((t) => !t.isIncome)
        .fold<double>(0, (s, t) => s + t.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat Transaksi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: _pilihRentang,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambah,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          HistorySummaryCard(
            totalMasuk: totalMasuk,
            totalKeluar: totalKeluar,
          ),
          HistorySearchField(
            onChanged: (v) => setState(() => _query = v),
          ),
          if (_range != null)
            DateRangeChip(
              range: _range!,
              onClear: () => setState(() => _range = null),
            ),
          FilterChipsRow(
            filters: _filters,
            selected: _selectedFilter,
            onSelected: (f) => setState(() => _selectedFilter = f),
          ),
          Expanded(
            child: data.isEmpty
                ? const EmptyHistory()
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final tx = data[index];
                      final showHeader =
                          index == 0 || !isSameDay(data[index - 1].date, tx.date);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showHeader)
                            DateHeader(label: labelTanggal(tx.date)),
                          Dismissible(
                            key: Key(tx.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20.0),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (_) => _hapus(tx),
                            child: TransactionTile(
                              transaction: tx,
                              onTap: () => _edit(tx),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}