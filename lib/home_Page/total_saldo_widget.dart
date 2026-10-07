import 'package:flutter/material.dart';

class TotalSaldoCard extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;

  const TotalSaldoCard({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
  });

  double get totalSaldo => totalIncome - totalExpense;

  String _formatRupiah(double value) {
    final isNegative = value < 0;
    final absVal = value.abs().toStringAsFixed(0);
    final buffer = StringBuffer();
    for (int i = 0; i < absVal.length; i++) {
      final posFromEnd = absVal.length - i;
      buffer.write(absVal[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) buffer.write('.');
    }
    return '${isNegative ? '-' : ''}Rp$buffer';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Total Saldo', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            Text(
              _formatRupiah(totalSaldo),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _saldoRow(Icons.arrow_downward, const Color.fromARGB(255, 76, 152, 175), 'Income',
                      _formatRupiah(totalIncome)),
                ),
                Expanded(
                  child: _saldoRow(Icons.arrow_upward, const Color.fromARGB(255, 244, 54, 54), 'Expense',
                      _formatRupiah(-totalExpense)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _saldoRow(IconData icon, Color color, String label, String value) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}