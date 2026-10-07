import 'package:flutter/material.dart';

class AppTheme {
  static const Color violet = Color(0xFF8B5CF6);
  static const Color blue = Color(0xFF3B82F6);
  static const Color cyan = Color(0xFF22D3EE);
  static const Color night = Color(0xFF0A0620);
  static const Color panel = Color(0xFF150D35);

  static ThemeData get dark {
    final scheme = const ColorScheme.dark().copyWith(
      primary: violet,
      secondary: cyan,
      tertiary: blue,
      surface: panel,
      onSurface: const Color(0xFFE0E7FF),
    );

    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: night,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1065),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: panel,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: cyan.withValues(alpha: 0.4)),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: cyan,
        textColor: Color(0xFFE0E7FF),
      ),
      iconTheme: const IconThemeData(color: cyan),
      dividerColor: violet.withValues(alpha: 0.3),
      switchTheme: SwitchThemeData(
        thumbColor: const WidgetStatePropertyAll(cyan),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? violet.withValues(alpha: 0.7)
              : Colors.white24,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: violet,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: violet,
          foregroundColor: Colors.white,
        ),
      ),
      dialogTheme: const DialogThemeData(backgroundColor: panel),
    );
  }
}

class HologramAppBarBackground extends StatelessWidget {
  const HologramAppBarBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    if (!dark) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppTheme.violet,
            AppTheme.blue,
            AppTheme.cyan,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.cyan.withValues(alpha: 0.5),
            blurRadius: 18,
          ),
        ],
      ),
    );
  }
}