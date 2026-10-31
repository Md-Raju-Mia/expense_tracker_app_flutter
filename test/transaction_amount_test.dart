import 'package:flutter_test/flutter_test.dart';
import 'package:fleet_wise_user_app/domain/entities/transaction_amount.dart';
import 'package:fleet_wise_user_app/ui/expense/utils/normalize_amount_input.dart';

void main() {
  test('parses supported decimal input directly into integer minor units', () {
    final cases = {
      '1': 100,
      '12.5': 1250,
      '12.50': 1250,
      '.50': 50,
      '12.': 1200,
      ' 0.29 ': 29,
      '00012.05': 1205,
      '0.01': 1,
    };
    for (final entry in cases.entries) {
      final amount = TransactionAmount.parse(entry.key);
      expect(amount.minorUnits, entry.value, reason: entry.key);
      expect(
        TransactionAmount.fromDouble(amount.value).minorUnits,
        entry.value,
      );
    }
  });

  test('does not silently round or reinterpret unsupported input', () {
    for (final value in [
      '',
      ' ',
      '0',
      '0.00',
      '.00',
      '-1',
      '+1',
      'NaN',
      'Infinity',
      '1e3',
      '1,000.00',
      '1 2',
      '12.345',
      '1.000',
      '.',
      '12..3',
    ]) {
      expect(
        () => TransactionAmount.parse(value),
        throwsFormatException,
        reason: value,
      );
    }
  });

  test('enforces the safe boundary without truncation or overflow', () {
    final maximum = TransactionAmount.parse('9999999999999.99');
    expect(maximum.minorUnits, TransactionAmount.maxMinorUnits);
    expect(
      TransactionAmount.fromDouble(maximum.value).minorUnits,
      maximum.minorUnits,
    );
    expect(() => TransactionAmount.parse('10000000000000'), throwsRangeError);
    expect(
      () => TransactionAmount.parse('99999999999999999999999999999'),
      throwsRangeError,
    );
  });

  test(
    'rejects nonfinite and over-precision doubles at the write boundary',
    () {
      for (final value in [
        double.nan,
        double.infinity,
        double.negativeInfinity,
        0.0,
        -1.0,
        1.234,
        0.1 + 0.2,
      ]) {
        expect(
          () => TransactionAmount.fromDouble(value),
          throwsFormatException,
          reason: '$value',
        );
      }
    },
  );

  test('Bengali and mixed-script digits normalize without changing decimal meaning', () {
    expect(
      TransactionAmount.parse(normalizeAmountInput(' ১২৫০.৫০ ')).minorUnits,
      125050,
    );
    expect(
      TransactionAmount.parse(normalizeAmountInput('১২3.৪৫')).minorUnits,
      12345,
    );
    expect(normalizeAmountInput('১,০০০.০০'), '1,000.00');
    expect(
      () => TransactionAmount.parse(normalizeAmountInput('১,০০০.০০')),
      throwsFormatException,
    );
  });
}
