import 'package:equatable/equatable.dart';
import 'package:mobile_ultra/domain/cards/card_balance_entity.dart';

class CardsBalanceEntity with EquatableMixin {
  const CardsBalanceEntity({
    required this.cardsBalance,
    required this.totalBalance,
  });

  final List<CardBalanceEntity> cardsBalance;
  final double totalBalance;

  @override
  List<Object> get props => [
        cardsBalance,
        totalBalance,
      ];
}
