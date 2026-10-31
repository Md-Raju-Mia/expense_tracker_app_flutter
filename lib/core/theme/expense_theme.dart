import 'package:flutter/material.dart';

import 'app_theme.dart';

abstract final class ExpenseTheme {
  static const incomeColor = Color(0xFF176534);
  static const expenseColor = Color(0xFFB3261E);
  static const balanceColors = [Color(0xFF075E55), Color(0xFF08766A)];

  static final light = AppTheme.light.copyWith(
    appBarTheme: AppTheme.light.appBarTheme.copyWith(
      backgroundColor: AppTheme.light.colorScheme.primary,
      foregroundColor: AppTheme.light.colorScheme.onPrimary,
      centerTitle: false,
    ),
  );
}
