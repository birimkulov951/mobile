import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/cards/card_edit_entity.dart';
import 'package:mobile_ultra/extensions/iterable_extension.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/screens/base/mwwm/attached_cards/attached_cards_wm.dart';
import 'package:mobile_ultra/screens/card/v3/edit_card/edit_card_screen.dart';
import 'package:mobile_ultra/screens/card/v3/edit_card/edit_card_screen_model.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet_dialog.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/inject.dart';
import 'package:mobile_ultra/utils/url_launcher.dart';
import 'package:paynet_uikit/paynet_uikit.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class IEditCardScreenWidgetModel extends IWidgetModel
    with IAttachedCardsWidgetModelMixin {
  abstract final ValueNotifier<AttachedCard> card;

  abstract final ValueNotifier<bool> isButtonEnabled;

  abstract final ValueNotifier<bool> isLoading;

  abstract final ValueNotifier<int> cardColor;

  abstract final TextEditingController cardNameController;

  abstract final FocusNode focusNode;

  void deleteCard(String token);

  void onBackTap();

  void changeColor(int color);

  void onPublicOfferTap();

  void editCard(AttachedCard card);

  void trackPayments(AttachedCard card);
}

class EditCardScreenWidgetModel
    extends WidgetModel<EditCardScreen, EditCardScreenModel>
    with AttachedCardsWidgetModelMixin<EditCardScreen, EditCardScreenModel>
    implements IEditCardScreenWidgetModel {
  EditCardScreenWidgetModel(super.model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    cardNameController.addListener(() {
      _changeListener();
      if (cardNameController.text.isEmpty) {
        isButtonEnabled.value = false;
      }
    });
  }

  @override
  void dispose() {
    card.dispose();
    isButtonEnabled.dispose();
    cardColor.dispose();
    isLoading.dispose();
    super.dispose();
  }

  void _changeListener() {
    final _card = card.value;
    if (_card.color! != cardColor.value ||
        _card.name != cardNameController.text) {
      isButtonEnabled.value = true;
    }
  }

  @override
  void onBackTap() => Navigator.pop(context);

  @override
  late final ValueNotifier<int> cardColor =
      ValueNotifier(widget.arguments.attachedCard.color!);

  @override
  void changeColor(int color) {
    cardColor.value = color;
    _changeListener();
  }

  @override
  late final TextEditingController cardNameController =
      TextEditingController(text: widget.arguments.attachedCard.name);

  @override
  final FocusNode focusNode = FocusNode();

  @override
  void onPublicOfferTap() async {
    if (await UrlLauncher.canLaunchUrl(Const.TRACK_PAYMENTS_OFFER)) {
      await UrlLauncher.launchUrl(Const.TRACK_PAYMENTS_OFFER,
          mode: LaunchMode.externalApplication);
    }
  }

  @override
  late final ValueNotifier<AttachedCard> card =
      ValueNotifier(widget.arguments.attachedCard);

  @override
  final ValueNotifier<bool> isButtonEnabled = ValueNotifier(false);

  @override
  void deleteCard(String token) async {
    final result = await deleteCardBottomSheet();
    if (result == true) {
      isLoading.value = true;
      final success = await model.deleteCard(token);
      isLoading.value = false;
      if (success) {
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  void editCard(AttachedCard card) async {
    isLoading.value = true;
    final result = await model.editCard(
      CardEditEntity(
        name: cardNameController.text,
        token: card.token,
        order: card.order!,
        color: cardColor.value,
        main: card.isMain ?? false,
      ),
    );
    isLoading.value = false;
    if (result == true) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  void trackPayments(AttachedCard _card) async {
    final isSubscribed = _card.subscribed ?? false;
    final confirmPressed = await _confirmBottomSheet(isSubscribed);
    if (confirmPressed == true) {
      isLoading.value = true;
      final response = await model.trackPayments(
        token: _card.token,
        account: _card.login,
        subscribe: !isSubscribed,
      );
      if (response != null && response.success) {
        final cardsBalances = await model.getActualBalance();
        if (cardsBalances != null) {
          final cardBalance = cardsBalances.cardsBalance
              .firstWhereOrNull((element) => element.token == _card.token);
          _card.balance = cardBalance!.balance / 100;
        }
        _card.subscribeLastDate = response.subscribedDate;
        _card.subscribed = !isSubscribed;
        card.value = _card;
      }
      isLoading.value = false;
    }
  }

  Future<bool?> _confirmBottomSheet(bool isSubscribed) async {
    return await viewAndroidModalSheetDialog(
      context: context,
      title: isSubscribed
          ? locale.getText('track_payments_off')
          : locale.getText('track_payments_on'),
      message: isSubscribed
          ? locale.getText('track_payments_hint_off')
          : locale.getText('track_payments_hint_on'),
      confirmBtnTitle: isSubscribed
          ? locale.getText('track_off')
          : locale.getText('track_on'),
      confirmBtnTextStyle: isSubscribed
          ? Typographies.textMediumError
          : Typographies.textMediumAccent,
      cancelBtnTitle: locale.getText('cancel'),
      cancelBtnTextStyle: Typographies.caption1Secondary,
    );
  }

  @override
  void onErrorHandle(Object error) {
    super.onErrorHandle(error);
  }
}

EditCardScreenWidgetModel editCardScreenWidgetModelFactory(_) =>
    EditCardScreenWidgetModel(EditCardScreenModel(cardsRepository: inject()));
