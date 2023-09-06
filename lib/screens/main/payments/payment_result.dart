import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/main.dart' show appTheme, locale, pref;
import 'package:mobile_ultra/net/payment/attach_paynet_id_presenter.dart';
import 'package:mobile_ultra/net/payment/favorite_presenter.dart';
import 'package:mobile_ultra/net/payment/model/bill.dart';
import 'package:mobile_ultra/net/payment/model/payment.dart';
import 'package:mobile_ultra/net/payment/paynetid_presenter.dart';
import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';
import 'package:mobile_ultra/screens/main/payments/receipt.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/fields/text.dart';
import 'package:mobile_ultra/ui_models/various/label.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/locale_helper.dart';
import 'package:mobile_ultra/utils/route_utils.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

/// Фрагмент (сообщение) о результате выполнения операции по оплате
/// arguments: [0] - payment instance; [1] - merchant

//Todo remove!
class PaymentResultWidget extends StatefulWidget {
  static const Tag = '/paymentResult';

  @override
  State<StatefulWidget> createState() => PaymentResultWidgetState();
}

class PaymentResultWidgetState extends BaseInheritedTheme<PaymentResultWidget> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  Payment? payment;
  MerchantEntity? merchant;
  Bill? bill;

  String? contentText;
  bool isFavorite = false, showLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final List<dynamic>? arguments = getListArgumentFromContext(context);

    payment = arguments?[0];
    merchant = arguments?[1];
    bill = arguments?[2];
  }

  @override
  Widget get formWidget => Stack(
        children: <Widget>[
          Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              leading: SizedBox(),
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        LocaleBuilder(
                          builder: (_, locale) => Text(
                            locale.getText(payment?.resp == 0
                                ? 'pay_success'
                                : 'pay_fail'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: payment?.resp == 0
                                    ? ColorNode.Green
                                    : ColorNode.Red,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -.2),
                          ),
                        ),
                        Visibility(
                          visible: payment?.resp != 0,
                          child: Text(payment?.message ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                height: 1.5,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            payment?.additionMessage ?? '',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 32),
                          child: getAdditionInfo,
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Visibility(
                          visible: payment?.resp == 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              /*Expanded(
                            child: VerticalIconButtonV2(
                              title: locale.getText('create_autopay'),
                              color: ColorNode.itemBg,
                              svgIconName: 'autopay',
                              onTap: () async {
                                final result = await Navigator.pushNamed(
                                  context, getAutoPayWidgetTag(merchant.id),
                                  arguments: [
                                    AutoPaymentType.Create,
                                    merchant,
                                    Reminder(account: bill.account, payBill: jsonDecode(bill.requestJson))
                                  ]
                                ) ?? false;

                                if (result)
                                  ReminderPresenter.list().getList();
                              },
                            ),
                          ),
                          Expanded(
                            child: VerticalIconButtonV2(
                              title: locale.getText('attach_account'),
                              svgIconName: 'add_account',
                              color: ColorNode.itemBg,
                              onTap: onAttachAccount,
                            ),
                          ),
                          Expanded(
                            child: VerticalIconButtonV2(
                              title: locale.getText('favorite_account'),
                              svgIconName: 'favorite',
                              iconColor: isFavorite ? Colors.black : Colors.white,
                              color: ColorNode.Red,
                              onTap: onAttemptToAddFavorite,
                            ),
                          ),
                          Expanded(
                            child: VerticalIconButtonV2(
                              title: locale.getText('pay_again'),
                              svgIconName: 'fast_payment',
                              color: ColorNode.itemBg,
                              textColor: Colors.grey,
                              onTap: () => Navigator.pop(context),
                            ),
                          ),*/
                            ],
                          ),
                        ),
                        Visibility(
                          visible: payment?.resp == 0,
                          child: RoundedButton(
                              title: 'show_details',
                              color: appTheme.backgroundColor,
                              bg: appTheme.iconTheme.color ?? ColorNode.Green,
                              margin: const EdgeInsets.only(top: 25),
                              onPressed: () async {
                                final result = await Navigator.pushNamed<bool?>(
                                      context,
                                      ReceiptWidget.Tag,
                                      arguments: payment,
                                    ) ??
                                    false;

                                if (result) Navigator.pop(context, true);
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: RoundedButton(
                            bg: Colors.transparent,
                            child: Label(
                              text: 'back_to_menu',
                              weight: FontWeight.w500,
                            ),
                            onPressed: () => Navigator.pop(context, true),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          LoadingWidget(
            showLoading: showLoading,
          )
        ],
      );

  Widget get getAdditionInfo {
    Color? color;
    String message = '';

    switch (payment?.additionInfo?.logLevel) {
      case 1:
        break;
      case 2:
        color = ColorNode.Orange;
        break;
      default:
        color = ColorNode.Red;
        break;
    }

    switch (locale.prefix) {
      case LocaleHelper.English:
        message = payment?.additionInfo?.infoTextEn ?? '';
        break;
      case LocaleHelper.Uzbek:
        message = payment?.additionInfo?.infoTextUz ?? '';
        break;
      default:
        message = payment?.additionInfo?.infoTextRu ?? '';
        break;
    }

    return Text(
      message,
      style: TextStyle(
        fontSize: 17,
        color: color,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Future<bool> onInputTextDialog(String title, String hint) async =>
      await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6))),
          title: Text(title,
              textScaleFactor: (pref?.isAcceptPhoneScaleFactore ?? false)
                  ? MediaQuery.of(context).textScaleFactor
                  : 1.0,
              style: TextStyle(color: Colors.black)),
          content: CustomTextField(
            hint,
            action: TextInputAction.done,
            onChanged: (value) => contentText = value,
          ),
          actions: <Widget>[
            RoundedButton(
              child: TextLocale(
                'cancel',
                textScaleFactor: (pref?.isAcceptPhoneScaleFactore ?? false)
                    ? MediaQuery.of(context).textScaleFactor
                    : 1.0,
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                contentText = null;
                Navigator.pop(context, false);
              },
            ),
            RoundedButton(
              child: TextLocale(
                'save',
                textScaleFactor: (pref?.isAcceptPhoneScaleFactore ?? false)
                    ? MediaQuery.of(context).textScaleFactor
                    : 1.0,
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () => Navigator.pop(context, true),
            )
          ],
        ),
      ) ??
      false;

  void onAttemptToAddFavorite() async {
    if (isFavorite) return;

    if (await onInputTextDialog(
        locale.getText('favorite'), locale.getText('input_favorite_name'))) {
      onChangeFormState(showLoad: true);
      FavoritePresenter.lastTrans(
        id: payment?.id,
        onFail: _onFavoriteFail,
        onGetLastTrans: _onGetLastTrans,
      );
    }
  }

  void onAttachAccount() async {
    if (await onInputTextDialog(
        locale.getText('attaching_account'), locale.getText('comment'))) {
      onChangeFormState(showLoad: true);

      if (bill?.id != null) {
        AttachPaynetIdPresenter.attach(
          bill!.id!,
          comment: contentText ?? '',
          onAttachEvent: (error) {
            if (error != null) {
              onFail(error);
              return;
            }

            PaynetIdPresenter.getList();

            onChangeFormState();
            onSuccess(locale.getText('added'));
          },
        );
      }
    }
  }

  void onChangeFormState({bool showLoad = false}) => setState(() {
        showLoading = showLoad;
      });

  void onFail(String message) {
    onChangeFormState();
    showDialog(
        context: context,
        builder: (BuildContext context) => showMessage(
            context, locale.getText('error'), message,
            onSuccess: () => Navigator.pop(context)));
  }

  void onSuccess(String message) => scaffoldKey.currentState?.showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          backgroundColor: appTheme.textTheme.bodyText2?.color,
          content: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: 20,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  message,
                  style: appTheme.textTheme.bodyText2?.copyWith(
                      fontSize: 15, color: appTheme.scaffoldBackgroundColor),
                ),
              ),
            ),
          ),
        ),
      );

  void _onFavoriteFail(String error, errorBody) =>
      onFail(locale.getText('no_added'));

  void _onFavoriteSuccess({data}) {
    contentText = null;
    isFavorite = !isFavorite;

    onChangeFormState();
    onSuccess(locale.getText('added'));
  }

  void _onGetLastTrans({data}) => FavoritePresenter.newFavorite(
        data: {
          'billId': data.billId,
          'name': contentText,
        },
        onFail: _onFavoriteFail,
        onSuccess: _onFavoriteSuccess,
      );
}
