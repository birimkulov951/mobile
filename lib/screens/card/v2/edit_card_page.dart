import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ultra/main.dart' show db, locale, homeData;
import 'package:mobile_ultra/net/card/main_presenter.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/card/model/card_been.dart';
import 'package:mobile_ultra/net/card/model/new_card.dart';
import 'package:mobile_ultra/net/card/model/track.dart';
import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';
import 'package:mobile_ultra/screens/card/v2/card_name_edit_widget.dart';
import 'package:mobile_ultra/screens/card/v2/number_switcher_widget.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/buttons/button_border.dart';
import 'package:mobile_ultra/ui_models/card/v2/card_widget.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet_dialog.dart';
import 'package:mobile_ultra/ui_models/various/color_list.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/ui_models/various/title1.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/url_launcher.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';
import 'package:sprintf/sprintf.dart';

//todo remove Abdurahmon
class EditCardPage extends StatefulWidget {
  final AttachedCard card;

  const EditCardPage({
    required this.card,
  });

  @override
  State<StatefulWidget> createState() => EditCardPageState();
}

class EditCardPageState extends BaseInheritedTheme<EditCardPage> {
  final _cardNameCtrl = TextEditingController();

  int? _colorIndex;
  int _order = 0;

  List<CardBean> beans = [];

  bool _showLoading = false;
  bool _result = false;

  late List<AttachedCard> onlyAttachedCardsAndBonus;

  @override
  void initState() {
    super.initState();
    onlyAttachedCardsAndBonus = homeData!.cards
        .where((element) => element.type != Const.BONUS)
        .toList(growable: false);
    db?.readCardBeans().then((values) => beans.addAll(values));

    _cardNameCtrl.text = widget.card.name ?? '';

    _colorIndex = widget.card.color;
    _order = widget.card.order ?? _order;
  }

  @override
  void dispose() {
    beans.clear();

    _cardNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget get formWidget => WillPopScope(
        child: Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: TextLocale('edit_card'),
                titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
              ),
              body: Container(
                height: double.maxFinite,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 157),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 12),
                      CardWidget(
                        uCard: widget.card,
                        newColorIndex: _colorIndex,
                      ),
                      const SizedBox(height: 24),
                      ItemContainer(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 24, 16, 30),
                              child: InkWell(
                                child: LocaleBuilder(
                                  builder: (_, locale) => TextField(
                                    controller: _cardNameCtrl,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      labelText: locale.getText('card_name'),
                                    ),
                                  ),
                                ),
                                onTap: attemptChangeCardName,
                              ),
                            ),
                            HorizontalColorList(
                              selectedColorId: _colorIndex,
                              onSelect: (index) => setState(() {
                                _colorIndex = index;
                              }),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 30, 16, 30),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                      'assets/graphics_redesign/pos.svg'),
                                  const SizedBox(width: 16),
                                  TextLocale(
                                    'card_position',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  const Spacer(),
                                  NumberSwitcherWidget(
                                    number: _order,
                                    onDecrease: changeOrder,
                                    onIncrease: changeOrder,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: widget.card.type == Const.UZCARD &&
                            widget.card.status != CardStatus.EXPIRED,
                        child: ItemContainer(
                          margin: const EdgeInsets.only(top: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Title1(
                                text: 'track_payments',
                                padding:
                                    const EdgeInsets.fromLTRB(16, 24, 16, 12),
                                weight: FontWeight.w700,
                              ),
                              Title1(
                                text: 'track_payments_hint',
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 24),
                                color: ColorNode.MainSecondary,
                                size: 16,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextLocale('service_coast',
                                        style: TextStyle(
                                          fontSize: 16,
                                        )),
                                    LocaleBuilder(
                                      builder: (_, locale) => Text(
                                        sprintf(
                                            locale.getText(
                                              'track_payments_price',
                                            ),
                                            ['1 000']),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Builder(builder: (ctx) {
                                if (widget.card.subscribed ?? false) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, top: 24, right: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextLocale(
                                              'track_payments_activated_at',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              widget.card.subscribeLastDate ==
                                                      null
                                                  ? ''
                                                  : DateFormat('dd.MM.yyyy')
                                                      .format(DateFormat(
                                                              "yyyy-MM-dd'T'HH:mm:ss")
                                                          .parse(widget.card
                                                              .subscribeLastDate!)),
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      RoundedButtonBorder(
                                        title: 'track_off',
                                        padding: const EdgeInsets.fromLTRB(
                                          16,
                                          28,
                                          16,
                                          16,
                                        ),
                                        onPressed:
                                            attemptChangePaymentsTrackingState,
                                      ),
                                    ],
                                  );
                                } else {
                                  return RoundedButton(
                                      title: 'track_on',
                                      margin: const EdgeInsets.fromLTRB(
                                        16,
                                        28,
                                        16,
                                        16,
                                      ),
                                      onPressed:
                                          attemptChangePaymentsTrackingState);
                                }
                              }),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: InkWell(
                                  child: LocaleBuilder(
                                    builder: (_, locale) => RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                          text: locale.getText(
                                              'track_payments_offer_1'),
                                          style: TextStyle(
                                            color: ColorNode.MainSecondary,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: locale.getText(
                                                  'track_payments_offer_2'),
                                              style: TextStyle(
                                                color: ColorNode.Link,
                                              ),
                                            )
                                          ]),
                                    ),
                                  ),
                                  onTap: () async {
                                    if (await UrlLauncher.canLaunchUrl(
                                        Const.TRACK_PAYMENTS_OFFER)) {
                                      UrlLauncher.launchUrl(Const.TRACK_PAYMENTS_OFFER);
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                left: 1,
                right: 1,
                bottom: 0,
                child: Container(
                  color: ColorNode.Background,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RoundedButton(
                        title: 'save_changes',
                        onPressed: isEnableChangeButton()
                            ? () => attemptChangeCard()
                            : null,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      RoundedButton(
                        title: 'remove_card',
                        color: ColorNode.MainSecondary,
                        onPressed: attemptDeleteCard,
                        bg: Colors.transparent,
                      ),
                    ],
                  ),
                )),
            LoadingWidget(
              showLoading: _showLoading,
              withProgress: true,
            ),
          ],
        ),
        onWillPop: () async {
          Navigator.pop(context, _result);
          return false;
        },
      );

  bool isEnableChangeButton() =>
      _colorIndex != widget.card.color ||
      _order != widget.card.order ||
      _cardNameCtrl.text != widget.card.name;

  void changeOrder(int order) => setState(() {
        _order += order;
        if (_order <= 0) {
          _order = 1;
        } else {
          if (_order > (onlyAttachedCardsAndBonus.length)) {
            _order = onlyAttachedCardsAndBonus.length;
          }
        }
      });

  void onLoading({bool showLoading = true}) =>
      setState(() => _showLoading = showLoading);

  void onError(String message, {dynamic errorBody}) {
    onLoading(showLoading: false);
    onShowError(errorBody != null ? errorBody['title'] : message);
  }

  void onCardChanged(card) async {
    onLoading(showLoading: false);

    if (card.status == null && card.token == null && card.name == null)
      onError(locale.getText('incorrect_date'));
    else {
      final index =
          homeData?.cards.indexWhere((card) => card.token == widget.card.token);
      if (index != null && index != -1) {
        card.balance = widget.card.balance;

        homeData?.cards.removeAt(index);
        homeData?.cards.add(card);
      }
      Navigator.pop(context, true);
    }
  }

  void onCardDeleted() {
    onLoading(showLoading: false);
    homeData?.cards.removeWhere((card) => card.token == widget.card.token);
    Navigator.pop(context, true);
  }

  void onTrackPaymentsChanged(bool result, String? dateMillis) {
    onLoading(showLoading: false);
    if (result) {
      setState(() {
        final subscribed = widget.card.subscribed ?? false;

        widget.card.subscribed = !subscribed;
        widget.card.subscribeLastDate = dateMillis;
        _result = true;
      });
    }
  }

  void onShowError(String error) => showModalBottomSheet(
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

  Future<void> attemptChangeCardName() async {
    final result = await viewModalSheet<String?>(
      context: context,
      child: CardNameEditWdiget(
        oldName: _cardNameCtrl.text,
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() => _cardNameCtrl.text = result);
    }
  }

  Future<void> attemptChangeCard() async {
    onLoading();
    MainPresenter.cardEdit(
        data: NewCard(
          token: widget.card.token,
          name: _cardNameCtrl.text,
          main: widget.card.isMain,
          color: _colorIndex,
          order: _order,
        ),
        onError: onError,
        onSuccess: onCardChanged);
  }

  Future<void> attemptDeleteCard() async {
    var result = await viewModalSheetDialog(
            context: context,
            title: locale.getText('confirm_delete_card'),
            message: locale.getText('removing_card_hint'),
            confirmBtnTitle: locale.getText('remove_card'),
            cancelBtnTitle: locale.getText('cancel'),
            confirmBtnTextStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: ColorNode.Red)) ??
        false;

    if (result == true) {
      onLoading();

      final token = widget.card.token;

      if (token != null) {
        MainPresenter.cardDelete(
          token,
          onError: onError,
          onSuccess: onCardDeleted,
        );
      }
    }
  }

  Future<void> attemptChangePaymentsTrackingState() async {
    final isSubscribed = widget.card.subscribed ?? false;

    var result = await viewModalSheetDialog(
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
              ? TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ColorNode.Red,
                )
              : null,
          cancelBtnTitle: locale.getText('cancel'),
        ) ??
        false;

    if (result) {
      onLoading();
      MainPresenter.trackPayments(
        data: TrackPayments(
                token: widget.card.token,
                subscribe: !isSubscribed,
                account: widget.card.login)
            .toJson(),
        onError: onError,
        onSuccess: onTrackPaymentsChanged,
      );
    }
  }
}
