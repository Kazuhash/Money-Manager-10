import 'package:flutter/material.dart';
import '../../models/transaction_model.dart';
import 'date.dart';
import 'widgets/date_header.dart';
import 'widgets/empty_history.dart';
import 'widgets/filters.dart';
import 'widgets/tile.dart';
import 'widgets/summary_card.dart';
import 'widgets/search.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  static const _filters = ['Semua', 'Masuk', 'Keluar'];

  late final List<Transaction> _transactions = [
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

  String _selectedFilter = 'Semua';
  String _query = '';

  List<Transaction> get _visibleTransactions {
    final q = _query.trim().toLowerCase();
    final hasil = _transactions.where((tx) {
      if (_selectedFilter == 'Masuk' && !tx.isIncome) return false;
      if (_selectedFilter == 'Keluar' && tx.isIncome) return false;
      if (q.isNotEmpty && !tx.title.toLowerCase().contains(q)) return false;
      return true;
    }).toList();
    hasil.sort((a, b) => b.date.compareTo(a.date));
    return hasil;
  }

 void _hapus(Transaction tx) {
  final index = _transactions.indexWhere((item) => item.id == tx.id);
  setState(() => _transactions.removeAt(index));

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text('${tx.title} berhasil dihapus'),
        action: SnackBarAction(
          label: 'Urungkan',
          onPressed: () => setState(() => _transactions.insert(index, tx)),
        ),
      ),
    );
}

  void _showSnack(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan)),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () => _showSnack('Fitur Kalender Rentang Tanggal Terbuka'),
          ),
        ],
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
                              onTap: () => _showSnack(
                                'Membuka Form Edit untuk: ${tx.title}',
                              ),
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