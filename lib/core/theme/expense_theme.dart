import 'package:flutter/material.dart';

// Preserve the source app's Material defaults instead of inheriting posts styling.
abstract final class ExpenseTheme {
  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.teal,
      primary: Colors.teal,
      secondary: Colors.tealAccent,
    ),
    useMaterial3: true,
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey[50],
    ),
  );
}
