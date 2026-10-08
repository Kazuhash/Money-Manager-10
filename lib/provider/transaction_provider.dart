import 'package:flutter/material.dart';
import '../history/transaction_store.dart';
import '../models/transaction_model.dart';

/// Single source of truth for transactions. Home, History and the Add
/// Transaction page all read and write through this provider.
class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];
  bool _isLoaded = false;

  TransactionProvider() {
    _load();
  }

  bool get isLoaded => _isLoaded;
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
    await _save();
  }

  Future<void> updateTransaction(Transaction updated) async {
    final index = _transactions.indexWhere((t) => t.id == updated.id);
    if (index == -1) return;
    _transactions = List.of(_transactions)..[index] = updated;
    notifyListeners();
    await _save();
  }

  /// Removes a transaction and returns the index it had, so it can be
  /// put back with [restoreTransaction] (undo). Returns -1 if not found.
  int removeTransaction(String id) {
    final index = _transactions.indexWhere((t) => t.id == id);
    if (index == -1) return -1;
    _transactions = List.of(_transactions)..removeAt(index);
    notifyListeners();
    _save();
    return index;
  }

  void restoreTransaction(int index, Transaction transaction) {
    final list = List.of(_transactions);
    list.insert(index.clamp(0, list.length), transaction);
    _transactions = list;
    notifyListeners();
    _save();
  }

  Future<void> _load() async {
    final saved = await TransactionStore.load();
    _transactions = saved ?? _seed();
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> _save() => TransactionStore.save(_transactions);

  // Sample data shown on first launch, before anything has been saved.
  List<Transaction> _seed() => [
        Transaction(
          id: '1',
          title: 'Gaji Bulanan',
          amount: 5000000,
          date: DateTime.now(),
          category: 'Gaji',
          isIncome: true,
        ),
        Transaction(
          id: '2',
          title: 'Makan Siang Nasi Padang',
          amount: 25000,
          date: DateTime.now(),
          category: 'Makanan',
          isIncome: false,
        ),
        Transaction(
          id: '3',
          title: 'Beli Bensin',
          amount: 50000,
          date: DateTime.now(),
          category: 'Transport',
          isIncome: false,
        ),
        Transaction(
          id: '4',
          title: 'Token Listrik Kost',
          amount: 100000,
          date: DateTime.now().subtract(const Duration(days: 1)),
          category: 'Tagihan',
          isIncome: false,
        ),
        Transaction(
          id: '5',
          title: 'Transfer dari mom',
          amount: 500000,
          date: DateTime.now().subtract(const Duration(days: 1)),
          category: 'Lainnya',
          isIncome: true,
        ),
        Transaction(
          id: '6',
          title: 'Belanja monthly Alfamart',
          amount: 150000,
          date: DateTime.now().subtract(const Duration(days: 3)),
          category: 'Belanja',
          isIncome: false,
        ),
      ];
}
