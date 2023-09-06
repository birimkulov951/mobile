import 'package:flutter/material.dart';
import 'package:mobile_ultra/main.dart' show homeData;
import 'package:mobile_ultra/net/card/humo_presenter.dart';
import 'package:mobile_ultra/net/card/main_presenter.dart';
import 'package:mobile_ultra/net/card/model/bonus_per_month.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/card/uzcard_presenter.dart';
import 'package:mobile_ultra/utils/const.dart';

abstract class BaseCardsState<T extends StatefulWidget> extends State<T> {
  bool isLoading = false;
  int retryCounter = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 250), () {
      onUpdateCommonBalance();
    });
  }

  void onUpdateCommonBalance();

  void getPaynetUCards() => setState(() {
        final isEmpty = homeData?.cards.isEmpty ?? false;
        isLoading = homeData == null || isEmpty;

        MainPresenter.cardList(
            onError: (error, {dynamic errorBody}) {
              onError(error, errorBody: errorBody);
              setState(() => isLoading = false);

              if (homeData == null || isEmpty) {
                retryCounter++;
              }
            },
            onSussecc: onGetPaynetUCards);
      });

  void updateBalances() => MainPresenter.cardsBalances(
        onSussecc: onGetCardsBalances,
        onError: onError,
      );

  void getBonusPerMonth() => MainPresenter.getBonusPerMonth(
        onSuccess: onGetBonusPerMonth,
        onError: onError,
      );

  void onGetPaynetUCards() => setState(() {
        retryCounter = 0;
        isLoading = false;
        getBonusPerMonth();
      });

  void onGetCardsBalances(bool updateCardsHash) {
    if (updateCardsHash) {
      getPaynetUCards();
    } else {
      getBonusPerMonth();
      if (mounted) {
        setState(() {});
      }
    }
  }

  void getUCards() => updateUCards(Const.UZCARD);

  void updateUCards(int? cardType) {
    if (cardType == Const.UZCARD) {
      UzcardPresenter.cardList(
          onError: (error, {dynamic errorBody}) {
            invalidateCards(Const.UZCARD);
            updateUCards(Const.HUMO);
          },
          onSuccess: () => onUzcardUpdate(Const.UZCARD));
    } else {
      HumoPresenter.cardList(
          onError: (error, {dynamic errorBody}) {
            invalidateCards(Const.HUMO);
            getBonusPerMonth();
          },
          onSuccess: () => onHumoUpdate(Const.HUMO));
    }
  }

  void invalidateCards(int type) {
    if (mounted) {
      setState(() {
        homeData?.cards
            .where((card) => card.type == type)
            .forEach((card) => card.status = CardStatus.INVALID);
      });
    }
  }

  void onUzcardUpdate(int type) {
    onCardsUpdated(type);
    updateUCards(Const.HUMO);
  }

  void onHumoUpdate(int type) {
    onCardsUpdated(type);
    getBonusPerMonth();
  }

  void onCardsUpdated(int type) {}

  void onGetBonusPerMonth(BonusPerMonth bonus) {
    if (mounted) {
      setState(() {});
    }
  }

  void onError(String error, {dynamic errorBody}) {}
}
