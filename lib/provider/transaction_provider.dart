import 'package:flutter/material.dart';
import '../history/transaction_store.dart';
import '../models/transaction_model.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];

  TransactionProvider() {
    _load();
  }

  List<Transaction> get transactions => List.unmodifiable(_transactions);

  double get totalIncome => _transactions
      .where((t) => t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => _transactions
      .where((t) => !t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpense;

  Future<void> addTransaction(Transaction transaction) async {
    _transactions = [transaction, ..._transactions];
    notifyListeners();
    await TransactionStore.save(_transactions);
  }

  Future<void> _load() async {
    final saved = await TransactionStore.load();
    if (saved == null) return;
    _transactions = saved;
    notifyListeners();
  }
}
