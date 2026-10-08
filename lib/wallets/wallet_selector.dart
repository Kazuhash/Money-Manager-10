import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/wallet_provider.dart';
import 'wallet_page.dart';

class WalletSelector extends StatelessWidget {
  const WalletSelector({super.key});

  static const _allWallets = '__all_wallets__';
  static const _manageWallets = '__manage_wallets__';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WalletProvider>();
    final selectedValue = provider.selectedWalletId ?? _allWallets;

    return PopupMenuButton<String>(
      tooltip: 'Pilih dompet',
      initialValue: selectedValue,
      onSelected: (value) async {
        if (value == _manageWallets) {
          await Navigator.push<void>(
            context,
            MaterialPageRoute(builder: (_) => const WalletPage()),
          );
          return;
        }
        try {
          await provider.selectWallet(
            value == _allWallets ? null : value,
          );
        } catch (error) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal memilih dompet: $error')),
            );
          }
        }
      },
      itemBuilder: (context) => [
        CheckedPopupMenuItem<String>(
          value: _allWallets,
          checked: provider.selectedWalletId == null,
          child: const Text('Semua dompet'),
        ),
        for (final wallet in provider.wallets)
          CheckedPopupMenuItem<String>(
            value: wallet.id,
            checked: provider.selectedWalletId == wallet.id,
            child: Text(wallet.name),
          ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: _manageWallets,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.settings_outlined),
            title: Text('Kelola dompet'),
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.account_balance_wallet_outlined),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                provider.selectedWalletName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13),
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
