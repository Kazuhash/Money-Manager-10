import 'package:flutter/foundation.dart';
import '../history/transaction_store.dart';
import 'transaction_model.dart';

class TransactionRepository extends ChangeNotifier {
  List<Transaction> _items = [];

  List<Transaction> get items => List.unmodifiable(_items);

  Future<void> load() async {
    _items = await TransactionStore.load() ?? _seed();
    notifyListeners();
  }

  void _persist() => TransactionStore.save(_items);

  void add(Transaction t) {
    _items.add(t);
    _persist();
    notifyListeners();
  }

  void update(Transaction t) {
    final i = _items.indexWhere((e) => e.id == t.id);
    if (i == -1) return;
    _items[i] = t;
    _persist();
    notifyListeners();
  }

  int remove(String id) {
    final i = _items.indexWhere((e) => e.id == id);
    if (i == -1) return -1;
    _items.removeAt(i);
    _persist();
    notifyListeners();
    return i;
  }

  void insertAt(int index, Transaction t) {
    final pos = index > _items.length ? _items.length : index;
    _items.insert(pos, t);
    _persist();
    notifyListeners();
  }

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
          category: 'Transportasi',
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