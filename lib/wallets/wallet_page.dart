import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/money_wallet.dart';
import '../models/transaction_model.dart';
import '../models/transaction_repo.dart';
import '../provider/wallet_provider.dart';
import '../settings_page/app_setting.dart';
import '../settings_page/app_theme.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  Future<void> _createWallet(BuildContext context) async {
    final nameController = TextEditingController();
    final balanceController = TextEditingController(text: '0');
    final formKey = GlobalKey<FormState>();
    final result = await showDialog<(String, double)>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Tambah dompet'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                autofocus: true,
                maxLength: 30,
                decoration: const InputDecoration(
                  labelText: 'Nama dompet',
                  hintText: 'Contoh: Rekening bank',
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Nama dompet wajib diisi'
                    : null,
              ),
              TextFormField(
                controller: balanceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Saldo awal',
                  prefixText: 'Rp ',
                ),
                validator: (value) {
                  final amount = double.tryParse(value?.trim() ?? '');
                  return amount == null || !amount.isFinite || amount < 0
                      ? 'Masukkan saldo awal yang valid'
                      : null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              Navigator.pop(dialogContext, (
                nameController.text.trim(),
                double.parse(balanceController.text.trim()),
              ));
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    nameController.dispose();
    balanceController.dispose();
    if (result == null || !context.mounted) return;

    try {
      await context.read<WalletProvider>().addWallet(
        name: result.$1,
        openingBalance: result.$2,
      );
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan dompet: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final wallets = context.watch<WalletProvider>().wallets;
    final transactions = context.watch<TransactionRepository>().items;
    final settings = context.watch<AppSettings>();
    final balances = _walletBalances(wallets, transactions);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dompet'),
        centerTitle: true,
        flexibleSpace: const HologramGradientBackground(
          lightModeGradient: AppTheme.hologramGradient,
        ),
        actions: [
          IconButton(
            tooltip: 'Tambah dompet',
            onPressed: () => _createWallet(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          for (final wallet in wallets)
            Card(
              child: ListTile(
                leading: CircleAvatar(child: Icon(_walletIcon(wallet))),
                title: Text(
                  wallet.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  '${_transactionCount(wallet, transactions)} transaksi',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      settings.formatMoney(balances[wallet.id] ?? 0),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                onTap: () async {
                  try {
                    await context.read<WalletProvider>().selectWallet(
                      wallet.id,
                    );
                    if (context.mounted) Navigator.pop(context);
                  } catch (error) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal memilih dompet: $error')),
                      );
                    }
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  static Map<String, double> _walletBalances(
    List<MoneyWallet> wallets,
    List<Transaction> transactions,
  ) {
    final balances = {
      for (final wallet in wallets) wallet.id: wallet.openingBalance,
    };
    for (final transaction in transactions) {
      final balance = balances[transaction.walletId];
      if (balance == null) continue;
      balances[transaction.walletId] =
          balance +
          (transaction.isIncome ? transaction.amount : -transaction.amount);
    }
    return balances;
  }

  static int _transactionCount(
    MoneyWallet wallet,
    List<Transaction> transactions,
  ) => transactions
      .where((transaction) => transaction.walletId == wallet.id)
      .length;

  static IconData _walletIcon(MoneyWallet wallet) =>
      wallet.id == MoneyWallet.defaultId
      ? Icons.account_balance_wallet
      : Icons.wallet;
}
