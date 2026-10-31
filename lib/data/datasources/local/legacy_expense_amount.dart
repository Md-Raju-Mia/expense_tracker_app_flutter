// One-time conversion of old REAL amounts to the nearest minor unit.
// Read the stored decimal spelling so 1.005 becomes 101, rather than depending
// on the binary floating-point result of amount * 100.
int legacyExpenseAmountToMinor(num amount) {
  if (!amount.isFinite) {
    throw const FormatException('Cannot migrate a nonfinite legacy amount');
  }
  final scientificParts = amount.abs().toString().toLowerCase().split('e');
  final decimalParts = scientificParts.first.split('.');
  final fraction = decimalParts.length == 2 ? decimalParts[1] : '';
  final digits = BigInt.parse('${decimalParts.first}$fraction');
  final exponent = scientificParts.length == 2
      ? int.parse(scientificParts[1])
      : 0;
  final shift = exponent - fraction.length + 2;
  final ten = BigInt.from(10);
  BigInt minor;
  if (shift >= 0) {
    minor = digits * ten.pow(shift);
  } else {
    final divisor = ten.pow(-shift);
    minor = digits ~/ divisor;
    // Half a minor unit rounds away from zero, including negative old rows.
    if ((digits % divisor) * BigInt.two >= divisor) {
      minor += BigInt.one;
    }
  }
  if (amount.isNegative) minor = -minor;
  final minimum = BigInt.parse('-9223372036854775808');
  final maximum = BigInt.parse('9223372036854775807');
  if (minor < minimum || minor > maximum) {
    throw const FormatException('Legacy amount exceeds SQLite INTEGER range');
  }
  return minor.toInt();
}
