import 'package:intl/intl.dart';

String expenseAmountInput(int minorUnits) {
  final amount = BigInt.from(minorUnits);
  final hundred = BigInt.from(100);
  final absolute = amount.abs();
  final whole = absolute ~/ hundred;
  final fraction = (absolute % hundred).toString().padLeft(2, '0');
  return '${amount.isNegative ? '-' : ''}$whole.$fraction';
}

String expenseAmount(BigInt minorUnits, String currencyCode, String locale) {
  final symbol = switch (currencyCode) {
    'BDT' => '৳',
    'INR' => '₹',
    'USD' => '\$',
    _ => '$currencyCode ',
  };
  final format = NumberFormat('0', locale);
  final hundred = BigInt.from(100);
  final absolute = minorUnits.abs();
  final whole = absolute ~/ hundred;
  final fraction = (absolute % hundred).toString().padLeft(2, '0');
  final sign = minorUnits.isNegative ? format.symbols.MINUS_SIGN : '';
  final digits = '$whole${format.symbols.DECIMAL_SEP}$fraction';
  final zero = format.symbols.ZERO_DIGIT.codeUnitAt(0);
  // Localize digits directly: converting a large total to double loses cents.
  final localized = digits.split('').map((character) {
    final digit = int.tryParse(character);
    return digit == null ? character : String.fromCharCode(zero + digit);
  }).join();
  final number = '$sign$localized';
  return '$symbol$number';
}
