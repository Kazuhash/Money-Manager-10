import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../transaction_page/add_transaction_page.dart';
import 'transaksi.dart';

import 'package:provider/provider.dart';

import '../models/transaction_repo.dart';
import '../settings_page/app_theme.dart';

enum PeriodeFilter { hariIni, mingguIni, bulanIni }

class MonefyHome extends StatefulWidget {
  const MonefyHome({super.key});

  @override
  State<MonefyHome> createState() => _MonefyHomeState();
}

class _MonefyHomeState extends State<MonefyHome> {
  static const green = Color(0xFF7CC896);
  static const red = Color(0xFFF08080);

  PeriodeFilter _periode = PeriodeFilter.bulanIni;
  DateTimeRange? _rentang;

  List<Transaksi> get _semua => context
      .watch<TransactionRepository>()
      .items
      .map(
        (t) => Transaksi(
          judul: t.title,
          jumlah: t.amount,
          tipe: t.isIncome
              ? TipeTransaksi.pemasukan
              : TipeTransaksi.pengeluaran,
          tanggal: t.date,
          kategori: t.category,
        ),
      )
      .toList();

  double get _totalSaldo => _semua.fold(
    0.0,
    (sum, t) =>
        sum + (t.tipe == TipeTransaksi.pemasukan ? t.jumlah : -t.jumlah),
  );

  bool _masukPeriode(DateTime t) {
    if (_rentang != null) {
      final awal = DateTime(
        _rentang!.start.year,
        _rentang!.start.month,
        _rentang!.start.day,
      );
      final akhirEksklusif = DateTime(
        _rentang!.end.year,
        _rentang!.end.month,
        _rentang!.end.day + 1,
      );
      return !t.isBefore(awal) && t.isBefore(akhirEksklusif);
    }

    final now = DateTime.now();
    final awalHari = DateTime(now.year, now.month, now.day);
    switch (_periode) {
      case PeriodeFilter.hariIni:
        return !t.isBefore(awalHari) &&
            t.isBefore(awalHari.add(const Duration(days: 1)));
      case PeriodeFilter.mingguIni:
        final awalMinggu = awalHari.subtract(Duration(days: now.weekday - 1));
        return !t.isBefore(awalMinggu);
      case PeriodeFilter.bulanIni:
        return t.year == now.year && t.month == now.month;
    }
  }

  List<Transaksi> get _terfilter {
    final list = _semua.where((t) => _masukPeriode(t.tanggal)).toList();
    list.sort((a, b) => b.tanggal.compareTo(a.tanggal));
    return list;
  }

  double _total(List<Transaksi> list, TipeTransaksi tipe) =>
      list.where((t) => t.tipe == tipe).fold(0.0, (sum, t) => sum + t.jumlah);

  String get _labelPeriode {
    if (_rentang != null) {
      return '${tanggalPendek(_rentang!.start)} - ${tanggalPendek(_rentang!.end)}';
    }

    switch (_periode) {
      case PeriodeFilter.hariIni:
        return 'hari ini';
      case PeriodeFilter.mingguIni:
        return 'minggu ini';
      case PeriodeFilter.bulanIni:
        return 'bulan ini';
    }
  }

  Future<void> _pilihRentang() async {
    final now = DateTime.now();
    final hasil = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 10),
      lastDate: now,
      initialDateRange: _rentang,
    );
    if (hasil != null && mounted) {
      setState(() => _rentang = hasil);
    }
  }

  void _bukaHalaman({required bool income}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddTransactionPage(initialIsIncome: income),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = _terfilter;
    final income = _total(data, TipeTransaksi.pemasukan);
    final expense = _total(data, TipeTransaksi.pengeluaran);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Moneger'),
        flexibleSpace: const HologramGradientBackground(
          lightModeGradient: AppTheme.hologramGradient,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'minus',
            backgroundColor: red,
            foregroundColor: Colors.white,
            onPressed: () => _bukaHalaman(income: false),
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 40),
          FloatingActionButton(
            heroTag: 'plus',
            backgroundColor: green,
            foregroundColor: Colors.white,
            onPressed: () => _bukaHalaman(income: true),
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Saldo',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    rupiah(_totalSaldo),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (_rentang == null)
            SegmentedButton<PeriodeFilter>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                  value: PeriodeFilter.hariIni,
                  label: Text('Hari ini'),
                ),
                ButtonSegment(
                  value: PeriodeFilter.mingguIni,
                  label: Text('Minggu ini'),
                ),
                ButtonSegment(
                  value: PeriodeFilter.bulanIni,
                  label: Text('Bulan ini'),
                ),
              ],
              selected: {_periode},
              onSelectionChanged: (s) => setState(() => _periode = s.first),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pilihRentang,
                  icon: const Icon(Icons.date_range),
                  label: Text(
                    _rentang == null
                        ? 'Pilih rentang tanggal'
                        : '${tanggalPendek(_rentang!.start)} - ${tanggalPendek(_rentang!.end)}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (_rentang != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Hapus filter rentang tanggal',
                  onPressed: () => setState(() => _rentang = null),
                  icon: const Icon(Icons.close),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ringkasan $_labelPeriode',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CustomPaint(
                          painter: _DonutPainter(
                            income: income,
                            expense: expense,
                            incomeColor: green,
                            expenseColor: red,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _legend(green, 'Pemasukan', rupiah(income)),
                            const SizedBox(height: 12),
                            _legend(red, 'Pengeluaran', rupiah(expense)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Transaksi terbaru',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (data.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: Text('Belum ada transaksi')),
            )
          else
            ...data.take(10).map(_itemTransaksi),
        ],
      ),
    );
  }

  Widget _legend(Color color, String label, String nilai) => Row(
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(nilai, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    ],
  );

  Widget _itemTransaksi(Transaksi t) {
    final masuk = t.tipe == TipeTransaksi.pemasukan;
    final warna = masuk ? green : red;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: warna.withValues(alpha: 0.2),
          child: Icon(
            masuk ? Icons.arrow_downward : Icons.arrow_upward,
            color: warna,
          ),
        ),
        title: Text(t.judul),
        subtitle: Text(tanggalPendek(t.tanggal)),
        trailing: Text(
          '${masuk ? '+' : '-'}${rupiah(t.jumlah)}',
          style: TextStyle(color: warna, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final double income;
  final double expense;
  final Color incomeColor;
  final Color expenseColor;

  _DonutPainter({
    required this.income,
    required this.expense,
    required this.incomeColor,
    required this.expenseColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 22.0;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    final total = income + expense;
    if (total == 0) {
      paint.color = Colors.grey.shade300;
      canvas.drawArc(rect, 0, 2 * math.pi, false, paint);
      return;
    }
    final sweepIncome = 2 * math.pi * (income / total);
    paint.color = incomeColor;
    canvas.drawArc(rect, -math.pi / 2, sweepIncome, false, paint);
    paint.color = expenseColor;
    canvas.drawArc(
      rect,
      -math.pi / 2 + sweepIncome,
      2 * math.pi - sweepIncome,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) =>
      old.income != income || old.expense != expense;
}
