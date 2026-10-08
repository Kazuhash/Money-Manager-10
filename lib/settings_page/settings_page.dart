import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/transaction_model.dart';
import 'app_setting.dart';
import 'category_management_page.dart';
import 'currency_page.dart';
import 'about_page.dart';
import 'app_theme.dart';

class SettingsPage extends StatelessWidget {
  final List<Transaction> transactions;

  const SettingsPage({super.key, this.transactions = const []});

  String _buildCsv() {
    final buffer = StringBuffer('id,title,amount,date,category,type\n');
    for (final t in transactions) {
      final title = t.title.replaceAll('"', '""');
      final category = t.category.replaceAll('"', '""');
      buffer.writeln(
        '${t.id},"$title",${t.amount},${t.date.toIso8601String()},"$category",${t.isIncome ? 'income' : 'expense'}',
      );
    }
    return buffer.toString();
  }

  Future<void> _exportData(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    if (transactions.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Belum ada transaksi untuk diexport')),
      );
      return;
    }
    await Clipboard.setData(ClipboardData(text: _buildCsv()));
    messenger.showSnackBar(
      SnackBar(
        content: Text('${transactions.length} transaksi disalin sebagai CSV'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Moneger'),
        centerTitle: true,
        flexibleSpace: const HologramGradientBackground(
          lightModeGradient: AppTheme.hologramGradient,
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Kelola Kategori'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CategoryManagementPage()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Mata Uang'),
            subtitle: Text(settings.currencySymbol),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CurrencyPage()),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text('Mode Gelap'),
            value: settings.isDark,
            onChanged: (value) async {
              try {
                await settings.setDark(value);
              } catch (error) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal menyimpan pengaturan tema: $error'),
                    ),
                  );
                }
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.file_download),
            title: const Text('Export Data'),
            subtitle: const Text('Salin semua transaksi sebagai CSV'),
            onTap: () => _exportData(context),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Info Aplikasi'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutPage()),
            ),
          ),
        ],
      ),
    );
  }
}
