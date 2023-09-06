import 'package:mobile_ultra/net/card/model/card.dart';

class MainData {
  final List<AttachedCard> cards;
  double totalBalance;

  MainData({
    this.cards = const [],
    this.totalBalance = 0,
  });

  factory MainData.fromJson(Map<String, dynamic> json) {
    final List<dynamic> cards = json['cards'] ?? [];

    return MainData(
        cards:
            List.generate(cards.length, (index) => AttachedCard.fromJson(cards[index])),
        totalBalance: (json['total_balance'] ?? 0) / 100);
  }
}
