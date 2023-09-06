import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/cards/card_addition_req_entity.dart';
import 'package:mobile_ultra/domain/cards/card_addition_result.dart';
import 'package:mobile_ultra/domain/cards/card_beans_result.dart';
import 'package:mobile_ultra/domain/cards/cards_balance_result.dart';
import 'package:mobile_ultra/repositories/cards_repository.dart';
import 'package:mobile_ultra/repositories/system_repository.dart';
import 'package:mobile_ultra/screens/base/mwwm/system/system_model.dart'
    show SystemModelMixin;
import 'package:mobile_ultra/screens/card/card_mvvm/exceptions/card_already_exists_exception.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/exceptions/card_not_active_exception.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/exceptions/card_not_found_exception.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/exceptions/card_not_found_or_sms_info_is_off_exception.dart';

class CardAdditionScreenModel extends ElementaryModel with SystemModelMixin {
  CardAdditionScreenModel({
    required SystemRepository systemRepository,
    required this.cardsRepository,
  }) {
    this.systemRepository = systemRepository;
  }

  @protected
  final CardsRepository cardsRepository;

  Future<CardAdditionResult> cardAdditionHumo(
    CardAdditionReqEntity cardAdditionRequest,
  ) async {
    try {
      final response =
          await cardsRepository.cardAdditionHumo(cardAdditionRequest);

      cardsRepository.saveCardToDB(response);

      return CardAdditionResult.success(response);
    } on CardAlreadyExistsException catch (error) {
      return CardAdditionResult.cardAlreadyExists(error);
    } on CardNotFoundException catch (error) {
      return CardAdditionResult.cardNotFound(error);
    } on CardNotFountOrSmsInfoIsOffException catch (error) {
      return CardAdditionResult.cardNotFountOrSmsInfoIsOff(error);
    } on CardNotActiveException catch (error) {
      return CardAdditionResult.cardNotActive(error);
    } on Object catch (error) {
      return CardAdditionResult.failed(error);
    }
  }

  Future<CardAdditionResult> cardAdditionUzcard(
    CardAdditionReqEntity cardAdditionRequest,
  ) async {
    try {
      final response =
          await cardsRepository.cardAdditionUzcard(cardAdditionRequest);

      cardsRepository.saveCardToDB(response);

      return CardAdditionResult.success(response);
    } on CardAlreadyExistsException catch (error) {
      return CardAdditionResult.cardAlreadyExists(error);
    } on CardNotFoundException catch (error) {
      return CardAdditionResult.cardNotFound(error);
    } on CardNotFountOrSmsInfoIsOffException catch (error) {
      return CardAdditionResult.cardNotFountOrSmsInfoIsOff(error);
    } on Object catch (error) {
      return CardAdditionResult.failed(error);
    }
  }

  Future<CardBeansResult> getCardBeans({bool isFromDB = true}) async {
    try {
      final response = await cardsRepository.getCardBeans(isFromDB: isFromDB);
      return CardBeansResult.success(response);
    } on Object catch (error) {
      return CardBeansResult.failed(error);
    }
  }

  Future<CardsBalanceResult> getCardBalance() async {
    try {
      final response = await cardsRepository.getCardsBalance();

      cardsRepository.updateCardsBalance(response);

      return CardsBalanceResult.success(response);
    } on Object catch (error) {
      return CardsBalanceResult.failed(error);
    }
  }
}
