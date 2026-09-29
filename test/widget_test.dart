import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_manager_uts/home_Page/monefy_home.dart';

void main() {
  testWidgets('Judul Monefy tampil', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: MonefyHome()),
    );

    expect(find.text('Monefy'), findsOneWidget);
  });

  testWidgets('Tombol tambah dan kurang tampil', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: MonefyHome()),
    );

    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byIcon(Icons.remove), findsOneWidget);
  });
}