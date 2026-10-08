import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_navigation.dart';
import 'provider/category_provider.dart';
import 'provider/transaction_provider.dart';
import 'settings_page/app_setting.dart';
import 'settings_page/app_theme.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppSettings()),
          ChangeNotifierProvider(create: (_) => CategoryProvider()),
          ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ],
        child: const MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: settings.themeMode,
      darkTheme: AppTheme.dark,
      home: const MainNavigation(),
    );
  }
}