class CardsItemArg {
  final Function(int) selectCard;
  final List<bool> selectedCards;

  CardsItemArg({
    required this.selectCard,
    required this.selectedCards,
  });
}
