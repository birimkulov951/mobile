class CardBean {
  final int? cardType;
  final String? bean;

  CardBean({
    this.cardType,
    this.bean,
  });

  @override
  String toString() => 'card type: $cardType; bean: $bean';
}
