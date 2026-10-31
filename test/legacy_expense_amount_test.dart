import 'package:fleet_wise_user_app/data/datasources/local/legacy_expense_amount.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('legacy decimals round to cents without binary multiply errors', () {
    final cases = <num, int>{
      0: 0,
      0.1: 10,
      0.29: 29,
      1.005: 101,
      -1.005: -101,
      12.345: 1235,
      -12.345: -1235,
      0.0049: 0,
      -0.005: -1,
      9.999: 1000,
      1e-7: 0,
      1e10: 1000000000000,
      9999999999999.99: 999999999999999,
    };
    for (final entry in cases.entries) {
      expect(
        legacyExpenseAmountToMinor(entry.key),
        entry.value,
        reason: '${entry.key}',
      );
    }
  });

  test(
    'unrepresentable legacy values fail rather than clamp or erase data',
    () {
      for (final amount in [
        double.nan,
        double.infinity,
        -double.infinity,
        1e100,
        -1e100,
      ]) {
        expect(() => legacyExpenseAmountToMinor(amount), throwsFormatException);
      }
      expect(
        legacyExpenseAmountToMinor(92233720368547758),
        9223372036854775800,
      );
      expect(
        legacyExpenseAmountToMinor(-92233720368547758),
        -9223372036854775800,
      );
    },
  );
}
