import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/money_wallet.dart';

class WalletProvider extends ChangeNotifier {
  static const _storageKey = 'money_wallets_v1';
  static const _selectedWalletKey = 'selected_wallet_v1';

  WalletProvider({required SharedPreferences preferences})
    : _preferences = preferences {
    final raw = preferences.getString(_storageKey);
    if (raw == null) return;
    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      throw const FormatException('Saved wallets must be a list.');
    }
    _wallets = decoded
        .map((entry) => MoneyWallet.fromJson(
              Map<String, dynamic>.from(entry as Map),
            ))
        .toList();
    if (_wallets.isEmpty) _wallets = [MoneyWallet.defaultWallet];
    if (_wallets.map((wallet) => wallet.id).toSet().length != _wallets.length) {
      throw const FormatException('Saved wallets contain duplicate IDs.');
    }
    final selectedId = preferences.getString(_selectedWalletKey);
    _selectedWalletId = selectedId != null &&
            _wallets.any((wallet) => wallet.id == selectedId)
        ? selectedId
        : null;
  }

  final SharedPreferences _preferences;
  List<MoneyWallet> _wallets = [MoneyWallet.defaultWallet];
  String? _selectedWalletId;

  List<MoneyWallet> get wallets => List.unmodifiable(_wallets);
  String? get selectedWalletId => _selectedWalletId;

  String get selectedWalletName => _selectedWalletId == null
      ? 'Semua dompet'
      : walletById(_selectedWalletId!)?.name ?? 'Semua dompet';

  Future<void> selectWallet(String? id) async {
    if (id != null && walletById(id) == null) {
      throw ArgumentError.value(id, 'id', 'Wallet does not exist.');
    }
    if (id == _selectedWalletId) return;
    final saved = id == null
        ? await _preferences.remove(_selectedWalletKey)
        : await _preferences.setString(_selectedWalletKey, id);
    if (!saved) throw StateError('Could not save selected wallet.');
    _selectedWalletId = id;
    notifyListeners();
  }

  MoneyWallet? walletById(String id) {
    for (final wallet in _wallets) {
      if (wallet.id == id) return wallet;
    }
    return null;
  }

  Future<void> addWallet({
    required String name,
    required double openingBalance,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Wallet name cannot be empty.');
    }
    if (!openingBalance.isFinite || openingBalance < 0) {
      throw ArgumentError.value(
        openingBalance,
        'openingBalance',
        'Opening balance must be zero or greater.',
      );
    }
    final wallet = MoneyWallet(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: trimmedName,
      openingBalance: openingBalance,
    );
    await _save([..._wallets, wallet]);
  }

  Future<void> _save(List<MoneyWallet> wallets) async {
    final saved = await _preferences.setString(
      _storageKey,
      jsonEncode(wallets.map((wallet) => wallet.toJson()).toList()),
    );
    if (!saved) throw StateError('Could not save wallets.');
    _wallets = wallets;
    notifyListeners();
  }
}
