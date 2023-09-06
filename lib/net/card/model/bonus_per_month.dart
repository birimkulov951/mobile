class BonusPerMonth {
  final int amount;
  final int month;

  const BonusPerMonth({
    this.amount = 0,
    this.month = -1,
  });

  factory BonusPerMonth.fromJson(Map<String, dynamic> json) => BonusPerMonth(
        amount: json['data']['amount'] ?? 0,
        month: json['data']['currentMonth'] ?? 1,
      );
}
