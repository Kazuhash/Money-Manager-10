import 'package:flutter/material.dart';
import 'app_theme.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info Aplikasi'),
        centerTitle: true,
        flexibleSpace: const HologramAppBarBackground(),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.account_balance_wallet,
                  size: 72, color: Color(0xFF81C995)),
              SizedBox(height: 16),
              Text(
                'Moneger',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('Versi 1.0.0'),
              SizedBox(height: 16),
              Text(
                'Aplikasi pencatat keuangan untuk mencatat pemasukan dan pengeluaran harian.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text('Proyek UTS Mobile Programming'),
            ],
          ),
        ),
      ),
    );
  }
}