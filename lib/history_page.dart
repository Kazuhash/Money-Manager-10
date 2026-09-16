import 'package:flutter/material.dart';
//rancangan awal
// membuat fitur riwayat transaksi dengan kategori masuk dan keluar(d0ne)
//membuat pengelompokan otomatis riwayat transaksi per tanggal (done)
//membuat fitur hapus riwaayt ransaksi dengan digeser ke kiri (done)
//membuat fitur filter riwayat dalam rentang tanggal (on progress)
//membuat fitur edit riwayat transaksi (on progress)
//membuat fitur tambah riwayat transaksi (on progress)
class DummyTransaction {
  final String id;
  final String title;
  final String category;
  final double amount;
  final bool isIncome;
  final String date;

  DummyTransaction({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.isIncome,
    required this.date,
  });
}

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  List<DummyTransaction> transactions = [
    DummyTransaction(
      id: '1',
      title: 'Gaji Bulanan',
      category: 'Gaji',
      amount: 5000000,
      isIncome: true,
      date: 'Hari Ini, 2 September 2026',
    ),
    DummyTransaction(
      id: '2',
      title: 'Makan Siang Nasi Padang',
      category: 'Makanan',
      amount: 25000,
      isIncome: false,
      date: 'Hari Ini, 2 September 2026',
    ),
    DummyTransaction(
      id: '3',
      title: 'Beli Bensin',
      category: 'Transport',
      amount: 50000,
      isIncome: false,
      date: 'Hari Ini, 2 September 2026',
    ),
    DummyTransaction(
      id: '4',
      title: 'Token Listrik Kost',
      category: 'Tagihan',
      amount: 100000,
      isIncome: false,
      date: 'Kemarin, 1 September 2026',
    ),
    DummyTransaction(
      id: '5',
      title: 'Transfer dari Ibu',
      category: 'Lainnya',
      amount: 500000,
      isIncome: true,
      date: 'Kemarin, 1 September 2026',
    ),
    DummyTransaction(
      id: '6',
      title: 'Belanja Bulanan Alfamart',
      category: 'Belanja',
      amount: 150000,
      isIncome: false,
      date: '30 Agustus 2026',
    ),
  ];

  String selectedFilter = 'Semua';

  @override
  Widget build(BuildContext context) {
    List<DummyTransaction> filteredTransactions = transactions.where((tx) {
      if (selectedFilter == 'Masuk') return tx.isIncome;
      if (selectedFilter == 'Keluar') return !tx.isIncome;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat Transaksi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur Kalender Rentang Tanggal Terbuka'),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['Semua', 'Masuk', 'Keluar'].map((filter) {
                final isSelected = selectedFilter == filter;
                return ChoiceChip(
                  label: Text(filter),
                  selected: isSelected,
                  selectedColor: Colors.deepPurple,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                  onSelected: (bool selected) {
                    setState(() {
                      selectedFilter = filter;
                    });
                  },
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: filteredTransactions.isEmpty
                ? const Center(child: Text('Tidak ada transaksi.'))
                : ListView.builder(
                    itemCount: filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final tx = filteredTransactions[index];

                      bool showHeader =
                          index == 0 ||
                          filteredTransactions[index - 1].date != tx.date;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showHeader)
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16.0,
                                top: 16.0,
                                bottom: 8.0,
                              ),
                              key: ValueKey('header_${tx.id}'),
                              child: Text(
                                tx.date,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),

                          Dismissible(
                            key: Key(tx.id),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20.0),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              setState(() {
                                transactions.removeWhere(
                                  (item) => item.id == tx.id,
                                );
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${tx.title} berhasil dihapus'),
                                ),
                              );
                            },

                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: tx.isIncome
                                    ? Colors.green.withAlpha(51)
                                    : Colors.red.withAlpha(51),
                                child: Icon(
                                  tx.isIncome
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  color: tx.isIncome
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              title: Text(
                                tx.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(tx.category),
                              trailing: Text(
                                '${tx.isIncome ? "+" : "-"}Rp ${tx.amount.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: tx.isIncome
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Membuka Form Edit untuk: ${tx.title}',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
