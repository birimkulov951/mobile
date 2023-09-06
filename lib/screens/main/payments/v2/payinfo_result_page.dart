import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/extensions/iterable_extension.dart';
import 'package:mobile_ultra/main.dart' show locale, pref, screenHeight;
import 'package:mobile_ultra/model/payment/merchant_fields.dart';
import 'package:mobile_ultra/model/payment/pay_params.dart';
import 'package:mobile_ultra/net/card/main_presenter.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/payment/model/bill.dart';
import 'package:mobile_ultra/net/payment/model/payment.dart';
import 'package:mobile_ultra/net/payment/payment_check_presenter.dart';
import 'package:mobile_ultra/net/payment/payment_presenter.dart';
import 'package:mobile_ultra/net/request_error.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';
import 'package:mobile_ultra/screens/card/addition/sms_confirmation_disabled.dart';
import 'package:mobile_ultra/screens/main/payments/v2/base_payment_page_state.dart';
import 'package:mobile_ultra/screens/main/payments/v2/payment_result/payment_result.dart';
import 'package:mobile_ultra/screens/main/payments/v2/payment_verification_widget.dart';
import 'package:mobile_ultra/ui_models/app_bar/custom_app_bar.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/card/v2/card_item.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet.dart';
import 'package:mobile_ultra/ui_models/payment/payinfo_category_item.dart';
import 'package:mobile_ultra/ui_models/payment/payinfo_field_item.dart';
import 'package:mobile_ultra/ui_models/rows/provider_bonus_layout.dart';
import 'package:mobile_ultra/ui_models/rows/receipt_row_item.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/ui_models/various/shape_circle.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';
import 'package:sprintf/sprintf.dart';

const _animationDuration = Duration(milliseconds: 250);

class PayinfoResultPage extends StatefulWidget {
  final bool isScrolled;
  final PaymentParams? paymentParams;
  final Bill? payBill;
  final JField jField;
  final AttachedCard? selectedCard;
  final Map<String, dynamic> requestBody;
  final List<MerchantField> fieldList;
  final Map<String, String?> details;
  final bool invoice;

  const PayinfoResultPage({
    required this.isScrolled,
    this.paymentParams,
    this.payBill,
    required this.jField,
    this.selectedCard,
    required this.requestBody,
    required this.fieldList,
    required this.details,
    required this.invoice,
  });

  @override
  State<StatefulWidget> createState() => PayinfoResultPageState();
}

class PayinfoResultPageState extends BaseInheritedTheme<PayinfoResultPage>
    with PaymentCheckView, PaymentView {
  bool viewLoading = false;
  String payAmount = '0';
  Bill? payBill;
  Map? responseBill;

  double _freeSpace = screenHeight;

  @override
  void initState() {
    super.initState();
    payBill = widget.payBill;

    if (payBill != null && payBill!.responseJson != null) {
      try {
        responseBill = jsonDecode(payBill!.responseJson!);
      } on Object catch (_) {
        responseBill = {};
      }
    }
  }

  num _calculateCommission() {
    final details = responseBill?['details'];
    final amount = num.tryParse(details?['amount']?['value'] ?? '');
    final payAmount = num.tryParse(details?['pay_amount']?['value'] ?? '');

    if (amount == null || payAmount == null) {
      return 0;
    }
    return amount - payAmount;
  }

  String _getCommission() {
    final commission = _calculateCommission();
    if (commission == 0) {
      return locale.getText('no_commission');
    }
    return sprintf(locale.getText('commission_amount'), [commission]);
  }

  @override
  void onGetFreeSpace({bool init = true, double freeSpace = 0}) {
    setState(() => _freeSpace = freeSpace);
  }

  @override
  Widget get formWidget => Stack(
        children: [
          Scaffold(
            appBar: PaynetAppBar(
              'payment_confirm',
            ),
            body: scrolledForm,
          ),
          LoadingWidget(
            showLoading: viewLoading,
          ),
        ],
      );

  Widget get scrolledForm => SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              key: topContainerKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.paymentParams?.merchant != null)
                    PayinfoCategoryItem(widget.paymentParams!.merchant!),
                  SizedBox(height: 3),
                  _getPaymentInfoLayout(),
                  cardLayout,
                ],
              ),
            ),
            AnimatedContainer(
              duration: _animationDuration,
              height: _freeSpace + MediaQuery.of(context).viewPadding.bottom,
              constraints: BoxConstraints(minHeight: 12),
            ),
            buttonLayout,
          ],
        ),
      );

  Widget get nonScrolledForm => Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.paymentParams?.merchant != null)
                PayinfoCategoryItem(widget.paymentParams!.merchant!),
              SizedBox(height: 3),
              _getPaymentInfoLayout(),
              cardLayout,
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                detailsLayout,
                buttonLayout,
              ],
            ),
          ),
        ],
      );

  Widget _getPaymentInfoLayout() {
    final Column details = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[],
    );

    Map<String, dynamic>? detailsJson;

    try {
      detailsJson = jsonDecode(widget.payBill?.responseJson ?? '{}')['details'];
      detailsJson?.remove('select');
    } on Exception catch (_) {}

    if (widget.jField == JField.CheckAndPay) {
      if (detailsJson != null && detailsJson.isNotEmpty) {
        switch (widget.paymentParams?.merchant?.id) {
          case 7289:
            //кинжный фонд
            widget.requestBody['params']['amount'] =
                detailsJson['amount']['value'];
            widget.requestBody['amount'] =
                widget.requestBody['params']['amount'];

            final Map<String, dynamic> params = widget.requestBody['params'];
            detailsJson.forEach((key, value) {
              if (params.containsKey(key) &&
                  (key != 'amount' &&
                      key != 'pay_amount' &&
                      key != 'school_region' &&
                      key != 'school_sector' &&
                      key != 'pay_account')) {
                details.children.add(PayinfoFieldItem(
                  label: value['label'],
                  value: value['value'],
                ));
              }
            });

            payAmount = sprintf(locale.getText('amount_format'), [
              formatAmount(double.parse(widget.requestBody['amount'] ?? '0'))
            ]);
            break;
          default:
            _setBaseInfo(details);

            final Map<String, dynamic> params = widget.requestBody['params'];

            detailsJson.forEach((key, value) {
              if (widget.requestBody.containsKey(key)) {
                widget.requestBody[key] = value['value'];
              }

              if (params.containsKey(key)) {
                params[key] = value['value'];

                final field = widget.fieldList
                    .firstWhereOrNull((element) => element.typeName == key);

                if (field != null && field.type == 'A') {
                  payAmount = sprintf(locale.getText('amount_format'),
                      [formatAmount(double.parse(value['value'] ?? '0'))]);
                }
              }
            });
            break;
        }
      }
    } else {
      _setBaseInfo(details);

      if (widget.invoice && detailsJson != null && detailsJson.isNotEmpty) {
        try {
          final Map<String, dynamic>? amountJson = detailsJson['amount'];
          if (amountJson != null) {
            details.children.add(PayinfoFieldItem(
              label: amountJson['label'],
              value: formatAmount(double.parse(amountJson['value'] ?? '0')),
              labelWeight: FontWeight.bold,
              valueWeight: FontWeight.bold,
            ));

            payAmount = sprintf(locale.getText('amount_format'),
                [formatAmount(double.parse(amountJson['value'] ?? '0'))]);
          }
        } on Exception catch (_) {}
      }
    }
    return details;
  }

  void _setBaseInfo(
    Column details,
  ) {
    widget.details.forEach((key, value) {
      final field =
          widget.fieldList.firstWhereOrNull((element) => element.label == key);

      if (field != null) {
        if (field.type == 'A') {
          if (value != null && value.isNotEmpty) {
            payAmount = sprintf(locale.getText('amount_format'),
                [formatAmount(double.parse(value))]);
          }
        } else {
          details.children.add(PayinfoFieldItem(
            label: key,
            value: value ?? '',
          ));
        }
      }
    });
  }

  Widget get cardLayout => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 16,
              top: 8,
            ),
            child: TextLocale(
              'where',
              style: TextStyles.captionButton.copyWith(
                color: ColorNode.MainSecondary,
              ),
            ),
          ),
          if (widget.selectedCard != null)
            CardItem(
              uCard: widget.selectedCard!,
              margin: EdgeInsets.only(top: 0),
              isSelected: false,
              backgroundColor: Colors.transparent,
            ),
        ],
      );

  Widget get buttonLayout => SizedBox(
        key: bottomContainerKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            detailsLayout,
            ItemContainer(
              margin: EdgeInsets.only(top: 4),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      top: 24,
                    ),
                    child: Text(
                      locale.getText('pay_amount'),
                      style: TextStyles.captionButton,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          payAmount,
                          style: TextStyles.title3,
                        ),
                        if (_onCashbackCalculate().isNotEmpty)
                          ProviderBonusLayout(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            value: _onCashbackCalculate(),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 4,
                    ),
                    child: Text(
                      _getCommission(),
                      style: TextStyles.caption1MainSecondary,
                    ),
                  ),
                  LocaleBuilder(
                    builder: (_, locale) => RoundedButton(
                      key: const Key(WidgetIds.paymentConfirmPayButton),
                      margin: EdgeInsets.only(
                        left: 16,
                        top: 28,
                        right: 16,
                        bottom: MediaQuery.of(context).viewPadding.bottom + 16,
                      ),
                      title: sprintf(locale.getText('pay'), [
                        payAmount,
                      ]),
                      loading: viewLoading,
                      onPressed: _attemptMakePay,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );

  Widget get detailsLayout => Visibility(
        visible: widget.paymentParams?.merchant?.printInfoCheque == 1,
        child: ItemContainer(
          child: ListTile(
            key: const Key(WidgetIds.paymentConfirmDetails),
            leading: CircleShape(
              child: SvgPicture.asset(Assets.cheque),
            ),
            title: TextLocale(
              'show_details',
              style: TextStyles.textRegular,
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: _viewPaymentDetails,
          ),
        ),
      );

  void _viewPaymentDetails() {
    Map<String, dynamic>? detailsJson;
    Map<String, dynamic>? selectJson;

    try {
      detailsJson = jsonDecode(widget.payBill?.responseJson ?? '{}')['details'];
      selectJson = detailsJson?.remove('select');
    } on Exception catch (_) {}

    Column paymentDetails = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[],
    );

    if (detailsJson != null && detailsJson.isNotEmpty) {
      if (selectJson != null) {
        try {
          List<dynamic> options = jsonDecode(selectJson['value'])['options'];

          final optionValue = options.firstWhere(
              (element) =>
                  element['value'] == widget.requestBody['params']['select'],
              orElse: () => null);

          if (optionValue != null) {
            paymentDetails.children.add(ReceiptItem(
              label: 'address',
              value: optionValue['name'],
            ));

            paymentDetails.children.add(ReceiptItem(
              label: 'balance',
              value: formatAmount(double.parse(
                  optionValue['balance']?.replaceAll(',', '.') ?? '0')),
              color: optionValue['balance'].toString().startsWith('-')
                  ? ColorNode.Red
                  : ColorNode.Green,
            ));
          }
        } on Exception catch (_) {}
      }

      detailsJson.forEach((key, value) {
        _localizeDetails(paymentDetails, key, value);
      });

      paymentDetails.children.add(SizedBox(height: 16));
    }

    viewModalSheet(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 16,
              top: 24,
              right: 16,
              bottom: 26,
            ),
            child: TextLocale(
              'show_details',
              style: TextStyles.title4,
            ),
          ),
          Expanded(
            child: LimitedBox(
              maxHeight:
                  MediaQuery.of(context).size.height - (kToolbarHeight + 72),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: paymentDetails,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _attemptMakePay() {
    if (!viewLoading) {
      setState(() => viewLoading = true);
    }

    if (widget.selectedCard?.sms ?? false) {
      if (widget.jField == JField.CheckAndPay) {
        PaymentCheckPresenter.check(this)
            .makeRequest(jsonEncode(widget.requestBody));
      } else {
        _makePay(payBill);
      }
    } else {
      _onSmsConfirmationDisabled();
    }
  }

  void _makePay(Bill? payBill) {
    Map<String, dynamic> requestBody = {
      'billId': payBill?.id,
      'token': widget.selectedCard?.token,
      'cardType': widget.selectedCard?.type,
    };

    if (widget.selectedCard?.type == Const.HUMO)
      PaymentPresenter.fromHumo(this).pay(requestBody);
    else
      PaymentPresenter.fromUzcard(this).pay(requestBody);
  }

  void _onFail(String error) {
    setState(() => viewLoading = false);

    showDialog(
      context: context,
      builder: (BuildContext context) => showMessage(
          context, locale.getText('error'), error,
          onSuccess: () => Navigator.pop(context)),
    );
  }

  @override
  void onCheckComplete({Bill? data, String? error}) {
    if (error != null || (data != null && data.status != 0)) {
      _onFail(error ?? data?.statusMessage ?? '');
      return;
    }

    payBill = data;

    if (payBill != null && payBill!.responseJson != null) {
      responseBill = jsonDecode(payBill!.responseJson!);
    }

    _makePay(payBill);
  }

  @override
  void onPaid({Payment? payment, String? error, errorBody}) async {
    dynamic payResult = payment;

    if (error != null) {
      if (errorBody != null && errorBody is Map<String, dynamic>) {
        final errResp = RequestError.fromJson(errorBody);
        if (errResp.status == 400 &&
            errResp.detail == 'not_card_owner_sms_sent') {
          payResult = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentVerificationWidget(
                id: payBill?.id,
                card: widget.selectedCard,
                onResendPressed: () => PaymentPresenter.resendCode(
                        widget.selectedCard?.type == Const.HUMO)
                    .pay(
                  {
                    'billId': payBill?.id,
                    'token': widget.selectedCard?.token,
                    'cardType': widget.selectedCard?.type,
                  },
                ),
              ),
            ),
          );

          if (payResult == null) {
            setState(() => viewLoading = false);
            return;
          }
        } else {
          _onFail(error);
          return;
        }
      } else {
        _onFail(error);
        return;
      }
    }

    pref?.madePay(true);
    MainPresenter.cardsBalances();

    Navigator.pop(
      context,
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentResultWidget(
            payment: payResult,
            merchant: widget.paymentParams?.merchant,
            bill: payBill,
            cardType: widget.selectedCard?.type,
            isFastPay: widget.paymentParams?.isFastPay ?? false,
          ),
        ),
      ),
    );
  }

  void _onSmsConfirmationDisabled() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => CardSMSConfirmationDisabledWidget())).then((value) {
      if (viewLoading) {
        setState(() => viewLoading = false);
      }
    });
  }

  String _onCashbackCalculate() {
    if (widget.selectedCard?.type != Const.BONUS &&
        widget.paymentParams != null &&
        widget.paymentParams?.merchant != null &&
        widget.paymentParams?.merchant?.bonus != 0) {
      var bonus = widget.paymentParams?.merchant?.bonus;

      var amount = double.parse(
          payAmount.replaceAll(locale.getText('sum'), '').replaceAll(' ', ''));

      if (bonus == 0 || amount == 0) {
        return '';
      }
      return '+${sprintf(locale.getText('amount_format'), [
            calculatePercentage(bonus!, amount)
          ])}';
    }
    return '';
  }

  void _localizeDetails(Column paymentDetails, String key, dynamic value) {
    printLog('Key $key, Label: ${value['label']},'
        ' Value: ${value['value'] ?? ''}');
    String? label;

    switch (key) {
      case 'agent_name':
        label = 'agent';
        break;
      case 'agent_inn':
        label = 'agent_inn';
        break;
      case 'provider_name':
        label = 'provider_name';
        break;
      case 'service_name':
        label = 'service';
        break;
      case 'time':
        label = 'datetime';
        break;
      case 'terminal_id':
        label = 'terminal_id';
        break;
      case 'transaction_id':
        label = 'check_number';
        break;
      case 'fio':
        label = 'fio';
        break;
      case 'address':
        label = 'address';
        break;
      case 'phone_number':
        label = 'phone_number';
        break;
      case 'amount':
        label = 'amount';
        break;
      case 'clientid':
        label = 'phone_number';
        break;
      case 'customer_code':
        label = 'account';
        break;
      default:
        label = value['label'];
        break;
    }

    paymentDetails.children.add(
      ReceiptItem(
        label: label,
        value: value['value'] ?? '',
      ),
    );
  }
}
