// Positive amounts for the currently supported two-decimal currencies.
class TransactionAmount {
  const TransactionAmount._(this.minorUnits);

  // A generous per-transaction limit, stored safely as a SQLite INTEGER.
  static const maxMinorUnits = 999999999999999;
  final int minorUnits;

  factory TransactionAmount.parse(String input) {
    final text = input.trim();
    final pattern = RegExp(r'^(?:[0-9]+(?:\.[0-9]{0,2})?|\.[0-9]{1,2})$');
    if (!pattern.hasMatch(text)) {
      throw const FormatException(
        'Expected a positive amount with at most two decimals',
      );
    }

    final parts = text.split('.');
    var wholeText = parts.first.replaceFirst(RegExp(r'^0+'), '');
    if (wholeText.isEmpty) wholeText = '0';
    if (wholeText.length > 13) throw RangeError('Amount is too large');
    final whole = int.parse(wholeText);
    final fraction = parts.length == 2 ? parts[1] : '';
    final minorUnits = whole * 100 + int.parse(fraction.padRight(2, '0'));
    if (minorUnits > maxMinorUnits) throw RangeError('Amount is too large');
    if (minorUnits == 0) {
      throw const FormatException('Amount must be greater than zero');
    }
    return TransactionAmount._(minorUnits);
  }

  factory TransactionAmount.fromMinorUnits(int minorUnits) {
    if (minorUnits <= 0) {
      throw const FormatException('Amount must be greater than zero');
    }
    if (minorUnits > maxMinorUnits) throw RangeError('Amount is too large');
    return TransactionAmount._(minorUnits);
  }
}
