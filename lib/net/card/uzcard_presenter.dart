import 'dart:convert';

import 'package:mobile_ultra/main.dart' show getAccessToken;
import 'package:mobile_ultra/net/card/base_ucard_presenter.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/card/model/new_card.dart';
import 'package:mobile_ultra/utils/const.dart';

class UzcardPresenter extends BaseUCardPresenter {
  UzcardPresenter(
    String path, {
    int type = BaseUCardPresenter.GET_CARDS,
    Function(String error, {dynamic errorBody})? onGetError,
    Function()? onGetUCards,
    Function(AttachedCard card)? onCardCreated,
    Function(AttachedCard card)? onCardVerified,
  }) : super(
          path,
          type,
          cardType: Const.UZCARD,
          onGetError: onGetError,
          onGetUCards: onGetUCards,
          onCardCreated: onCardCreated,
          onCardVerified: onCardVerified,
        );

  factory UzcardPresenter.cardList({
    Function(String error, {dynamic errorBody})? onError,
    Function()? onSuccess,
  }) =>
      UzcardPresenter('microservice/api/cards/v2/main',
          onGetError: onError, onGetUCards: onSuccess)
        .._execute();

  factory UzcardPresenter.newCard({
    NewCard? data,
    Function(String error, {dynamic errorBody})? onError,
    Function(AttachedCard card)? onSuccess,
  }) =>
      UzcardPresenter('microservice/api/cards/v6/register',
          onGetError: onError,
          onCardCreated: onSuccess,
          type: BaseUCardPresenter.ADD_NEW)
        .._execute(data: data);

  factory UzcardPresenter.cardVerification(
    String cardToken,
    String code, {
    Function(String error, {dynamic errorBody})? onError,
    Function(AttachedCard card)? onSuccess,
  }) =>
      UzcardPresenter(
        'microservice/api/cards/activate/$cardToken/$code',
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
