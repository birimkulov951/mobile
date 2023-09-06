import 'dart:convert';

import 'package:mobile_ultra/data/api/dto/responses/cards/cards_balance_response.dart';
import 'package:mobile_ultra/data/mappers/cards/cards_balance_mapper.dart';
import 'package:mobile_ultra/extensions/iterable_extension.dart';
import 'package:mobile_ultra/main.dart'
    show bonusPerMonthData, db, homeData, pref;
import 'package:mobile_ultra/net/card/model/bonus_per_month.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/card/model/card_been.dart';
import 'package:mobile_ultra/net/card/model/main_data.dart';
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/net/http_view.dart';
import 'package:mobile_ultra/utils/const.dart';

abstract class BaseUCardPresenter extends Http with HttpView {
  static const GET_CARDS = 0;
  static const ADD_NEW = 1;
  static const VERIFY = 2;
  static const DELETE = 3;
  static const EDIT = 4;
  static const TRACK_PAYMENTS = 5;
  static const BALANCES = 6;
  static const CARD_BEANS = 7;
  static const GET_BONUS_PER_MONTH = 8;

  int actionType;
  int? cardType;

  Function(String error, {dynamic errorBody})? onGetError;
  Function? onGetUCards;
  Function(bool)? onGetUCardsBalance;
  Function(AttachedCard card)? onCardCreated;
  Function(AttachedCard card)? onCardVerified;

  Function? onCardDeleted;
  Function(AttachedCard card)? onCardChanged;
  Function(bool result, String? date)? onTrackChanged;

  Function(List<CardBean>? cardBeans)? onGetCardBeans;

  Function(BonusPerMonth)? onGetBonusPerMonth;

  BaseUCardPresenter(
    String path,
    this.actionType, {
    this.cardType,
    this.onGetError,
    this.onGetUCards,
    this.onCardCreated,
    this.onCardVerified,
    this.onCardDeleted,
    this.onCardChanged,
    this.onTrackChanged,
    this.onGetUCardsBalance,
    this.onGetCardBeans,
    this.onGetBonusPerMonth,
  }) : super(path: path);

  @override
  void onFail(
    String details, {
    String? title,
    errorBody,
  }) =>
      onGetError?.call(
        title ?? details,
        errorBody: errorBody,
      );

  @override
  void onSuccess(body) async {
    switch (actionType) {
      case GET_CARDS:
        if (cardType == null) {
          final responseJson = jsonDecode(body);
          final hiddenBalanceList = pref?.hiddenCardBalance;

          homeData = MainData.fromJson(responseJson);

          /// TODO ок?
          final count = homeData?.cards.length ?? 0;

          for (int i = 0; i < count; i++) {
            var card = homeData!.cards[i];
            card.order ??= i + 1;
            card.status = CardStatus.VALID;
            card.hiddenBalance = hiddenBalanceList?.contains(card.token);

            card.viewTitle = card.type == Const.BONUS;
          }

          final list = homeData?.cards
                  .where((card) => card.type != Const.BONUS)
                  .toList(growable: false) ??
              [];

          if (list.isNotEmpty) {
            list.sort((one, two) {
              if (one.order == null || two.order == null) {
                return -1;
              }
              return one.order!.compareTo(two.order!);
            });
            list.first.viewTitle = true;
          }

          homeData?.cards.sort((one, two) {
            if (one.order == null || two.order == null) {
              return -1;
            }
            return one.order!.compareTo(two.order!);
          });
          db?.removeCards().then((value) {
            if (homeData?.cards != null) {
              db?.saveCards(homeData!.cards);
            }
          });
        } else {
          final data = MainData.fromJson(jsonDecode(body));

          if (data.cards.isEmpty ||
              (data.cards.length == 1 &&
                  data.cards.first.type == Const.BONUS)) {
            homeData?.cards.forEach((card) {
              if (card.type == cardType) card.status = CardStatus.INVALID;
            });
          } else {
            final hiddenBalanceList = pref?.hiddenCardBalance;

            /// TODO ок?
            final count = homeData?.cards.length ?? 0;

            for (int i = 0; i < count; i++) {
              final token = homeData!.cards[i].token;

              final card =
                  data.cards.firstWhereOrNull((card) => card.token == token);

              if (card != null) {
                card.hiddenBalance = hiddenBalanceList?.contains(token);
                card.order = homeData!.cards[i].order;
                card.viewTitle = card.type == Const.BONUS;

                homeData!.cards[i] = card;
              }
            }

            final list = homeData?.cards
                .where((card) => card.type != Const.BONUS)
                .toList(growable: false);
            if (list?.isNotEmpty ?? false) {
              list?.sort((one, two) {
                if (one.order == null || two.order == null) {
                  return -1;
                }
                return one.order!.compareTo(two.order!);
              });
              list?.first.viewTitle = true;
            }

            if (homeData?.cards != null) {
              db?.updateCardsBalanceFromCardList(homeData!.cards);
            }
          }
        }
        onGetUCards?.call();
        break;
      case BALANCES:
        final cardsBalanceEntity =
            CardsBalanceResponse.fromJson(jsonDecode(body)).toEntity();

        final cards = homeData?.cards.toList(growable: false) ?? [];

        if (cards.length < cardsBalanceEntity.cardsBalance.length) {
          onGetUCardsBalance?.call(true);
          return;
        } else if (cards.length > cardsBalanceEntity.cardsBalance.length) {
          await db?.removeCardsByCondition(cardsBalanceEntity.cardsBalance);
        }

        db?.updateCardsBalance(cardsBalanceEntity);
        onGetUCardsBalance?.call(false);
        break;
      case ADD_NEW:
        final card = AttachedCard.fromJson(jsonDecode(body));
        db?.saveCard(card);
        onCardCreated?.call(card);
        break;
      case VERIFY:
        final card = AttachedCard.fromJson(jsonDecode(body));
        db?.saveCard(card);
        onCardVerified?.call(card);
        break;
      case DELETE:
        onCardDeleted?.call();
        break;
      case EDIT:
        onCardChanged?.call(AttachedCard.fromJson(jsonDecode(body)));
        break;
      case TRACK_PAYMENTS:
        final result = jsonDecode(body);
        onTrackChanged?.call(
            result['success'], result['lastSubscribeDateTimestamp']);
        break;
      case CARD_BEANS:
        await db?.storeCardBeans(jsonDecode(body));
        onGetCardBeans?.call(await db?.readCardBeans());
        break;
      case GET_BONUS_PER_MONTH:
        final bonusPerMonth = BonusPerMonth.fromJson(jsonDecode(body));
        bonusPerMonthData = bonusPerMonth;
        onGetBonusPerMonth?.call(bonusPerMonth);
        break;
    }
  }
}
