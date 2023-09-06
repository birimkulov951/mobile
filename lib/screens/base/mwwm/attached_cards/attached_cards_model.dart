import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/cards/card_edit_entity.dart';
import 'package:mobile_ultra/domain/cards/cards_balance_entity.dart';
import 'package:mobile_ultra/net/card/model/main_data.dart';
import 'package:mobile_ultra/repositories/cards_repository.dart';

mixin AttachedCardsModelMixin on ElementaryModel {
  @protected
  late final CardsRepository cardsRepository;

  Future<bool> editCard(CardEditEntity cardEditEntity) async {
    try {
      await cardsRepository.editCard(cardEditEntity);
      return true;
    } on Object catch (e) {
      handleError(e);
    }
    return false;
  }

  Future<MainData?> getAttachedCards() async {
    try {
      final response = await cardsRepository.getAttachedCards();
      await cardsRepository.removeCards();
      cardsRepository.saveCards(response.cards);
      await cardsRepository.readStoredCards();
      return response;
    } on Object catch (e) {
      handleError(e);
    }
    return null;
  }

  Future<CardsBalanceEntity?> getActualBalance() async {
    try {
      final response = await cardsRepository.getCardsBalance();
      cardsRepository.updateCardsBalance(response);
      return response;
    } on Object catch (e) {
      handleError(e);
    }
    return null;
  }

  Future<bool> deleteCard(String token) async {
    try {
      await cardsRepository.deleteCard(token);
      return true;
    } on Object catch (e) {
      handleError(e);
    }
    return false;
  }
}
