import 'package:flutter_test/flutter_test.dart';
import 'package:money_manager_uts/history/transaction_store.dart';
import 'package:money_manager_uts/models/money_wallet.dart';
import 'package:money_manager_uts/provider/wallet_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('wallets persist with opening balance', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final provider = WalletProvider(preferences: preferences);

    expect(provider.wallets.single.id, MoneyWallet.defaultId);

    await provider.addWallet(name: 'Bank', openingBalance: 250000);
    final restored = WalletProvider(preferences: preferences);

    expect(restored.wallets, hasLength(2));
    expect(restored.wallets.last.name, 'Bank');
    expect(restored.wallets.last.openingBalance, 250000);

    await provider.selectWallet(restored.wallets.last.id);
    final withSelectionRestored = WalletProvider(preferences: preferences);
    expect(withSelectionRestored.selectedWalletId, restored.wallets.last.id);
  });

  test('transactions without wallet IDs stay in the default wallet', () async {
    SharedPreferences.setMockInitialValues({
      'transactions_v1': '''
        [{"id":"old","title":"Old transaction","amount":100,"date":"2026-01-01T00:00:00.000","category":"Food","isIncome":false}]
      ''',
    });

    final transactions = await TransactionStore.load();

    expect(transactions, hasLength(1));
    expect(transactions!.single.walletId, MoneyWallet.defaultId);
  });
}
