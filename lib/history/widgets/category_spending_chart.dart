import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../home_Page/transaksi.dart' show rupiah;
import '../../models/transaction_model.dart';

class CategorySpendingChart extends StatelessWidget {
  const CategorySpendingChart({
    super.key,
    required this.transactions,
    this.range,
  });

  final List<Transaction> transactions;
  final DateTimeRange? range;

  static const _colors = [
    Color(0xFF8B5CF6),
    Color(0xFF3B82F6),
    Color(0xFF22D3EE),
    Color(0xFF81C995),
    Color(0xFFF59E0B),
    Color(0xFFEF5DA8),
    Color(0xFFFB7185),
    Color(0xFF14B8A6),
  ];

  @override
  Widget build(BuildContext context) {
    final totals = <String, double>{};
    for (final transaction in transactions) {
      if (transaction.isIncome || !_isWithinRange(transaction.date)) continue;
      totals.update(
        transaction.category,
        (total) => total + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }

    final categories = totals.entries.toList()
      ..sort((a, b) {
        final byAmount = b.value.compareTo(a.value);
        return byAmount != 0 ? byAmount : a.key.compareTo(b.key);
      });
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: categories.isEmpty
            ? const Center(
                child: Text('Belum ada pengeluaran pada periode ini'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pengeluaran per kategori',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kategori pengeluaran tertinggi',
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          categories.first.key,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          rupiah(categories.first.value),
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 220,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 32,
                        sections: [
                          for (var i = 0; i < categories.length; i++)
                            PieChartSectionData(
                              value: categories[i].value,
                              color: _colors[i % _colors.length],
                              radius: 72,
                              title: '',
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (var i = 0; i < categories.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _colors[i % _colors.length],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(categories[i].key)),
                          const SizedBox(width: 8),
                          Text(
                            rupiah(categories[i].value),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  bool _isWithinRange(DateTime date) {
    if (range == null) return true;
    final start = DateTime(
      range!.start.year,
      range!.start.month,
      range!.start.day,
    );
    final endExclusive = DateTime(
      range!.end.year,
      range!.end.month,
      range!.end.day + 1,
    );
    return !date.isBefore(start) && date.isBefore(endExclusive);
  }
}
