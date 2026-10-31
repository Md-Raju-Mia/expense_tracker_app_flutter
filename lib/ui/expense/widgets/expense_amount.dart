import 'package:intl/intl.dart';

String expenseAmount(double amount, String currencyCode, String locale) {
  final symbol = switch (currencyCode) {
    'BDT' => '৳',
    'INR' => '₹',
    'USD' => '\$',
    _ => '$currencyCode ',
  };
  final number = NumberFormat('0.00', locale).format(amount);
  return '$symbol$number';
}
