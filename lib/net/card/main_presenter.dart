import 'dart:convert';

import 'package:mobile_ultra/main.dart' show getAccessToken;
import 'package:mobile_ultra/net/card/base_ucard_presenter.dart';
import 'package:mobile_ultra/net/card/model/bonus_per_month.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/card/model/card_been.dart';
import 'package:mobile_ultra/utils/const.dart';

class MainPresenter extends BaseUCardPresenter {
  MainPresenter(
    String path, {
    int type = BaseUCardPresenter.GET_CARDS,
    Function(String error, {dynamic errorBody})? onGetError,
    Function? onGetUCards,
    Function(bool)? onGetUCardsBalance,
    Function? onCardDeleted,
    Function(AttachedCard card)? onCardChanged,
    Function(bool result, String? date)? onTrackChanged,
    Function(List<CardBean>? cardBeans)? onGetCardBeans,
    Function(BonusPerMonth)? onGetBonusPerMonth,
  }) : super(
          path,
          type,
          onGetError: onGetError,
          onGetUCards: onGetUCards,
          onCardDeleted: onCardDeleted,
          onGetUCardsBalance: onGetUCardsBalance,
          onCardChanged: onCardChanged,
          onTrackChanged: onTrackChanged,
          onGetCardBeans: onGetCardBeans,
          onGetBonusPerMonth: onGetBonusPerMonth,
        );

  factory MainPresenter.cardList({
    Function(String error, {dynamic errorBody})? onError,
    Function? onSussecc,
  }) =>
      MainPresenter(
        'microservice/api/cards/v3/main',
        onGetError: onError,
        onGetUCards: onSussecc,
      ).._execute();

  factory MainPresenter.cardsBalances({
    Function(String error, {dynamic errorBody})? onError,
    Function(bool)? onSussecc,
  }) =>
      MainPresenter(
        'microservice/api/cards/v3/main/short',
        onGetError: onError,
        onGetUCardsBalance: onSussecc,
        type: BaseUCardPresenter.BALANCES,
      ).._execute();

  factory MainPresenter.cardDelete(
    String token, {
    Function(String error, {dynamic errorBody})? onError,
    Function? onSuccess,
  }) =>
      MainPresenter(
        'microservice/api/cards/delete/$token',
        type: BaseUCardPresenter.DELETE,
        onGetError: onError,
        onCardDeleted: onSuccess,
      ).._execute();

  factory MainPresenter.cardEdit({
    dynamic data,
    Function(String error, {dynamic errorBody})? onError,
    Function(AttachedCard card)? onSuccess,
  }) =>
      MainPresenter(
        'microservice/api/cards/v2/update',
        type: BaseUCardPresenter.EDIT,
        onGetError: onError,
        onCardChanged: onSuccess,
      ).._execute(data: data);

  factory MainPresenter.trackPayments({
    dynamic data,
    Function(String error, {dynamic errorBody})? onError,
    Function(bool result, String? date)? onSuccess,
  }) =>
      MainPresenter(
        'microservice/api/subscription',
        type: BaseUCardPresenter.TRACK_PAYMENTS,
        onGetError: onError,
        onTrackChanged: onSuccess,
      ).._execute(data: data);

  factory MainPresenter.getCardBeans({
    Function(String, {dynamic errorBody})? onError,
    Function(List<CardBean>? cardBeans)? onSuccess,
  }) =>
      MainPresenter(
        'microservice/api/cards/v1/getbeans',
        type: BaseUCardPresenter.CARD_BEANS,
        onGetError: onError,
        onGetCardBeans: onSuccess,
      ).._execute();

  factory MainPresenter.getBonusPerMonth({
    Function(String, {dynamic errorBody})? onError,
    Function(BonusPerMonth)? onSuccess,
  }) =>
      MainPresenter(
        'microservice/api/cards/bonus/amount',
        type: BaseUCardPresenter.GET_BONUS_PER_MONTH,
        onGetError: onError,
        onGetBonusPerMonth: onSuccess,
      ).._execute();

  void _execute({
    dynamic data,
  }) {
    switch (actionType) {
      case BaseUCardPresenter.GET_CARDS:
      case BaseUCardPresenter.BALANCES:
      case BaseUCardPresenter.GET_BONUS_PER_MONTH:
        makeGet(
          this,
          header: {Const.AUTHORIZATION: getAccessToken()},
        );
        break;
      case BaseUCardPresenter.DELETE:
        makeDelete(this, header: {Const.AUTHORIZATION: getAccessToken()});
        break;
      case BaseUCardPresenter.EDIT:
        makePut(this,
            header: {Const.AUTHORIZATION: getAccessToken()},
            data: jsonEncode(data));
        break;
      case BaseUCardPresenter.TRACK_PAYMENTS:
      case BaseUCardPresenter.CARD_BEANS:
        makePost(
          this,
          header: {Const.AUTHORIZATION: getAccessToken()},
          data: data != null ? jsonEncode(data) : null,
        );
        break;
    }
  }
}
