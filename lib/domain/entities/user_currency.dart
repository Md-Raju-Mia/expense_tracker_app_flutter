enum UserCurrency {
  bdt('BDT'),
  inr('INR'),
  usd('USD');

  const UserCurrency(this.code);
  final String code;
}
