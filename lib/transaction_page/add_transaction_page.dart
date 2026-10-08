import 'package:flutter/material.dart';
import 'transaction_form_widget.dart';

class AddTransactionPage extends StatelessWidget {
  final bool initialIsIncome;

  const AddTransactionPage({super.key, this.initialIsIncome = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Transaksi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: TransactionFormWidget(initialIsIncome: initialIsIncome),
      ),
    );
  }
}
