import 'package:elementary/elementary.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile_ultra/repositories/cards_repository.dart';
import 'package:mobile_ultra/repositories/home_repository.dart';
import 'package:mobile_ultra/screens/base/mwwm/attached_cards/attached_cards_model.dart';

class AllCardsScreenModel extends ElementaryModel
    with AttachedCardsModelMixin {
  AllCardsScreenModel({
    required CardsRepository cardsRepository,
    required this.homeRepository,
  }) {
    this.cardsRepository = cardsRepository;
  }

  @protected
  final HomeRepository homeRepository;

  bool get isBalanceVisible => homeRepository.isBalanceVisible();
}
