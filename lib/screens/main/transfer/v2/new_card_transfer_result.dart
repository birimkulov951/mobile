import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/net/card/main_presenter.dart';
import 'package:mobile_ultra/net/card/model/new_card.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';
import 'package:sprintf/sprintf.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/card/model/card.dart' as UCard;
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/utils/const.dart';

enum AddCardAction {
  ToEditCard,
  ToCardList,
  TryAgain,
  Close,
}

class NewCardTransferResultPage extends StatelessWidget {
  final UCard.AttachedCard card;
  final bool isSuccess;

  const NewCardTransferResultPage({
    Key? key,
    required this.card,
    required this.isSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const Spacer(),
            SvgPicture.asset(
                'assets/graphics_redesign/${isSuccess ? 'success' : 'fail'}.svg'),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: LocaleBuilder(
                builder: (_, locale) => Text(
                  isSuccess
                      ? sprintf(locale.getText('card_attached'),
                          [card.type == Const.UZCARD ? 'Uzcard' : 'Humo'])
                      : locale.getText('fail_adding_card'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: TextLocale(
                isSuccess
                    ? 'success_adding_card_hint_2'
                    : 'fail_adding_card_hint',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            const Spacer(),
            ItemContainer(
                backgroundColor: ColorNode.Main,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24)),
                padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RoundedButton(
                      title: isSuccess ? 'done' : 'try_again',
                      onPressed: () => Navigator.pop(
                          context,
                          isSuccess
                              ? AddCardAction.Close
                              : AddCardAction.TryAgain),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).viewPadding.bottom,
                    )
                  ],
                ))
          ],
        ),
      );

  Future<void> attemptChangeCard() async {
    MainPresenter.cardEdit(
      data: NewCard(
          token: card.token,
          name: card.name,
          main: card.isMain,
          color: 0,
          order: card.id),
      onError: onError,
      //  onSuccess: onCardChanged
    );
  }

  void onCardChanged(card, context) async {
    if (card.status == null && card.token == null && card.name == null)
      onError(locale.getText('incorrect_date'));
    else {
      final index =
          homeData?.cards.indexWhere((card) => card.token == card.token);
      if (index != null && index != -1) {
        card.balance = card.balance;

        homeData?.cards.removeAt(index);
        homeData?.cards.add(card);
      }
      Navigator.pop(context, true);
    }
  }

  void onError(String message, {dynamic errorBody}) {
    //  onShowError(errorBody != null ? errorBody['title'] : message);
  }

  void onShowError(String error, BuildContext context) => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        builder: (BuildContext context) => Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  )),
              Align(
                alignment: Alignment.topCenter,
                child: TextLocale(
                  'error',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Image.asset(
                  'assets/image/loop.png',
                  width: 180,
                  height: 102,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
                child: Text(
                  error,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      );
}
