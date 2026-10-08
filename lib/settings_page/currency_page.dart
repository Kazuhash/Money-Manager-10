import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_setting.dart';
import 'app_theme.dart';

class CurrencyPage extends StatelessWidget {
  const CurrencyPage({super.key});

  static const List<Map<String, String>> _currencies = [
    {'symbol': 'Rp', 'name': 'Rupiah Indonesia'},
    {'symbol': '\$', 'name': 'Dolar Amerika'},
    {'symbol': '€', 'name': 'Euro'},
    {'symbol': '¥', 'name': 'Yen Jepang'},
    {'symbol': 'RM', 'name': 'Ringgit Malaysia'},
    {'symbol': 'CN¥', 'name': 'Yuan China'},
  ];

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mata Uang'),
        centerTitle: true,
        flexibleSpace: const HologramAppBarBackground(),
      ),
      body: ListView(
        children: _currencies.map((c) {
          final selected = settings.currencySymbol == c['symbol'];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF81C995),
              foregroundColor: Colors.white,
              child: Text(c['symbol']!),
            ),
            title: Text(c['name']!),
            trailing: selected
                ? const Icon(Icons.check, color: Color(0xFF81C995))
                : null,
            onTap: () => settings.setCurrency(c['symbol']!),
          );
        }).toList(),
      ),
    );
  }
}