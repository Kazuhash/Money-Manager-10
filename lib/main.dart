import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_navigation.dart';
import 'settings_page/app_setting.dart';
import 'settings_page/app_theme.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (_) => AppSettings(),
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
      darkTheme: AppTheme.dark,
      themeMode: settings.themeMode,
      home: const MainNavigation(),
    );
  }
}