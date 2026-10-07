import 'package:flutter/material.dart';
import '../../../home_Page/transaksi.dart' show rupiah;
import '../../../models/transaction_model.dart';

IconData ikonKategori(String kategori) {
  switch (kategori) {
    case 'Gaji':
      return Icons.payments;
    case 'Makanan':
      return Icons.restaurant;
    case 'Transport':
      return Icons.directions_car;
    case 'Tagihan':
      return Icons.receipt_long;
    case 'Belanja':
      return Icons.shopping_bag;
    default:
      return Icons.category;
  }
}

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
        child: Icon(ikonKategori(tx.category), color: warna),
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