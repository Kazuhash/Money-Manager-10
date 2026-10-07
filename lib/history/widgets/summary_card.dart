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
            Text(
              rupiah(selisih),
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
                Text('Masuk: ${rupiah(totalMasuk)}',
                    style: const TextStyle(color: Colors.white)),
                Text('Keluar: ${rupiah(totalKeluar)}',
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}