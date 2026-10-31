String normalizeAmountInput(String input) {
  const bengaliDigits = '০১২৩৪৫৬৭৮৯';
  var normalized = input.trim();
  for (var digit = 0; digit < 10; digit++) {
    normalized = normalized.replaceAll(bengaliDigits[digit], digit.toString());
  }
  return normalized;
}
