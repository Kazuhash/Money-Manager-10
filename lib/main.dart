import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:device_preview/device_preview.dart';
import 'home_Page/total_saldo_widget.dart';

void main() {
  runApp(
    DevicePreview(enabled: !kReleaseMode, builder: (context) => const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: (context, child) => DevicePreview.appBuilder(context, child),
      title: 'Money Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Money Manager Home'),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: TotalSaldoCard(
            totalIncome: 5750000,
            totalExpense: 335000,
          ),
        ),
      ),
    );
  }
}