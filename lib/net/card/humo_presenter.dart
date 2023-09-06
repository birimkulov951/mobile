import 'dart:convert';

import 'package:mobile_ultra/main.dart' show getAccessToken;
import 'package:mobile_ultra/net/card/base_ucard_presenter.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/card/model/new_card.dart';
import 'package:mobile_ultra/utils/const.dart';

class HumoPresenter extends BaseUCardPresenter {
  HumoPresenter(
    String path, {
    int type = BaseUCardPresenter.GET_CARDS,
    Function(
      String error, {
      dynamic errorBody,
    })?
        onGetError,
    Function()? onGetUCards,
    Function(AttachedCard card)? onCardCreated,
    Function(AttachedCard card)? onCardVerified,
  }) : super(
          path,
          type,
          cardType: Const.HUMO,
          onGetError: onGetError,
          onGetUCards: onGetUCards,
          onCardCreated: onCardCreated,
          onCardVerified: onCardVerified,
        );

  factory HumoPresenter.cardList({
    Function(
      String error, {
      dynamic errorBody,
    })?
        onError,
    Function()? onSuccess,
  }) =>
      HumoPresenter('microservice/api/humo/cards/v4/main',
          onGetError: onError, onGetUCards: onSuccess)
        .._execute();

  factory HumoPresenter.newCard({
    required NewCard data,
    Function(
      String error, {
      dynamic errorBody,
    })?
        onError,
    Function(AttachedCard card)? onSuccess,
  }) =>
      HumoPresenter('microservice/api/humo/cards/v7/register',
          onGetError: onError,
          onCardCreated: onSuccess,
          type: BaseUCardPresenter.ADD_NEW)
        .._execute(data: data);

  factory HumoPresenter.cardVerification(
    String? cardToken,
    String? code, {
    Function(
      String error, {
      dynamic errorBody,
    })?
        onError,
    Function(AttachedCard card)? onSuccess,
  }) =>
      HumoPresenter(
        'microservice/api/humo/cards/activate/$cardToken/$code',
        onGetError: onError,
        onCardVerified: onSuccess,
        type: BaseUCardPresenter.VERIFY,
      ).._execute();

  void _execute({NewCard? data}) {
    switch (actionType) {
      case BaseUCardPresenter.GET_CARDS:
        makeGet(this, header: {Const.AUTHORIZATION: getAccessToken()});
        break;
      case BaseUCardPresenter.ADD_NEW:
        makePost(this,
            header: {Const.AUTHORIZATION: getAccessToken()},
            data: data == null ? null : jsonEncode(data.toJson()));
        break;
      case BaseUCardPresenter.VERIFY:
        makeGet(
          this,
          header: {Const.AUTHORIZATION: getAccessToken()},
        );
        break;
    }
  }
}
