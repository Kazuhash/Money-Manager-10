import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction_model.dart';
import '../models/transaction_repo.dart';
import 'date.dart';
import 'widgets/date_header.dart';
import 'widgets/empty_history.dart';
import 'widgets/filters.dart';
import 'widgets/tile.dart';
import 'widgets/summary_card.dart';
import 'widgets/search.dart';
import 'widgets/date_range.dart';
import 'widgets/transaction_form.dart';
import 'widgets/staggered_items.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  static const _filters = ['Semua', 'Masuk', 'Keluar'];

  String _selectedFilter = 'Semua';
  String _query = '';
  DateTimeRange? _range;

  List<Transaction> _filter(List<Transaction> semua) {
    final q = _query.trim().toLowerCase();
    final hasil = semua.where((tx) {
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
    if (baru == null || !mounted) return;
    context.read<TransactionRepository>().add(baru);
    _showSnack('${baru.title} berhasil ditambahkan');
  }

  Future<void> _edit(Transaction lama) async {
    final hasil = await showTransactionForm(context, initial: lama);
    if (hasil == null || !mounted) return;
    context.read<TransactionRepository>().update(hasil);
    _showSnack('${hasil.title} berhasil diperbarui');
  }

  void _hapus(Transaction tx) {
    final repo = context.read<TransactionRepository>();
    final index = repo.remove(tx.id);
    if (index == -1) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${tx.title} berhasil dihapus'),
          action: SnackBarAction(
            label: 'Urungkan',
            onPressed: () => repo.insertAt(index, tx),
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
    final repo = context.watch<TransactionRepository>();
    final data = _filter(repo.items);
    final totalMasuk = data
        .where((t) => t.isIncome)
        .fold<double>(0, (s, t) => s + t.amount);
    final totalKeluar = data
        .where((t) => !t.isIncome)
        .fold<double>(0, (s, t) => s + t.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Monefy',
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
                    padding: const EdgeInsets.only(bottom: 88),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final tx = data[index];
                      final showHeader =
                          index == 0 || !isSameDay(data[index - 1].date, tx.date);

                      return StaggeredItem(
                        index: index,
                        child: Column(
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
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              onDismissed: (_) => _hapus(tx),
                              child: TransactionTile(
                                transaction: tx,
                                onTap: () => _edit(tx),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}