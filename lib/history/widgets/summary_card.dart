import 'package:flutter/material.dart';
import '../../home_Page/transaksi.dart' show rupiah;

class HistorySummaryCard extends StatelessWidget {
  final double totalMasuk;
  final double totalKeluar;

  const HistorySummaryCard({
    super.key,
    required this.totalMasuk,
    required this.totalKeluar,
  });

  @override
  Widget build(BuildContext context) {
    final selisih = totalMasuk - totalKeluar;

    return Card(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      color: Colors.deepPurple,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Selisih', style: TextStyle(color: Colors.white70)),
            _AnimatedRupiah(
              value: selisih,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _AnimatedRupiah(
                  value: totalMasuk,
                  prefix: 'Masuk: ',
                  style: const TextStyle(color: Colors.white),
                ),
                _AnimatedRupiah(
                  value: totalKeluar,
                  prefix: 'Keluar: ',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedRupiah extends StatelessWidget {
  final double value;
  final String prefix;
  final TextStyle style;

  const _AnimatedRupiah({
    required this.value,
    required this.style,
    this.prefix = '',
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      builder: (context, v, _) => Text('$prefix${rupiah(v)}', style: style),
    );
  }
}