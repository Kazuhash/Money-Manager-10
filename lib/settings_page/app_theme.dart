import 'package:flutter/material.dart';

class AppTheme {
  static const Color green = Color(0xFF81C995);
  static const Color violet = Color(0xFF8B5CF6);
  static const Color blue = Color(0xFF3B82F6);
  static const Color cyan = Color(0xFF22D3EE);
  static const Color night = Color(0xFF0A0620);
  static const Color panel = Color(0xFF150D35);
  static const LinearGradient hologramGradient = LinearGradient(
    colors: [violet, blue, cyan],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: green,
      brightness: Brightness.light,
    );

    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF0FFF5),
      appBarTheme: const AppBarTheme(
        backgroundColor: green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: violet,
      ),
    );
  }

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
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: panel,
        selectedItemColor: cyan,
        unselectedItemColor: Colors.white60,
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

class HologramGradientBackground extends StatelessWidget {
  const HologramGradientBackground({
    super.key,
    this.child,
    this.lightModeGradient,
  });

  final Widget? child;
  final LinearGradient? lightModeGradient;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    if (!dark) {
      if (lightModeGradient == null) return child ?? const SizedBox.shrink();
      return Container(
        decoration: BoxDecoration(gradient: lightModeGradient),
        child: child,
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.hologramGradient,
        boxShadow: [
          BoxShadow(
            color: AppTheme.cyan.withValues(alpha: 0.5),
            blurRadius: 18,
          ),
        ],
      ),
      child: child,
    );
  }
}
