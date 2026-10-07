import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:provider/provider.dart';
import 'home_Page/monefy_home.dart';
import 'settings_page/app_setting.dart';
import 'settings_page/app_theme.dart';
import 'settings_page/settings_page.dart';

void main() => runApp(
  DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => ChangeNotifierProvider(
      create: (_) => AppSettings(),
      child: const MyApp(),
    ),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      darkTheme: AppTheme.dark,
      themeMode: settings.themeMode,
      home: const SettingsPage(),
    );
  }
}