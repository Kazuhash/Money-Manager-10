import 'package:flutter/material.dart';
import 'main_navigation.dart';

<<<<<<< HEAD
void main() => runApp(const MyApp());
=======

import 'history_page.dart';

void main() => runApp(
  DevicePreview(enabled: !kReleaseMode, builder: (context) => const MyApp()),
);
>>>>>>> parent of 54c4e6f (make folder history and move history_page.dart to it)

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainNavigation(),
    );
  }
}