import 'package:flutter/material.dart';
import '../../../home_Page/transaksi.dart' show rupiah;
import '../../../models/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;

  const TransactionTile({super.key, required this.transaction, this.onTap});

  @override
  Widget build(BuildContext context) {
    final tx = transaction;
    final warna = tx.isIncome ? Colors.green : Colors.red;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: warna.withAlpha(51),
        child: Icon(
          tx.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
          color: warna,
        ),
      ),
      title: Text(
        tx.title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(tx.category),
      trailing: Text(
        '${tx.isIncome ? "+" : "-"}${rupiah(tx.amount)}',
        style: TextStyle(fontWeight: FontWeight.bold, color: warna),
      ),
      onTap: onTap,
    );
  }
}