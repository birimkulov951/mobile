import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/domain/permission/permission_entity.dart';
import 'package:mobile_ultra/extensions/iterable_extension.dart';
import 'package:mobile_ultra/main.dart' show db, homeData, locale;
import 'package:mobile_ultra/model/payment/merchant_fields.dart';
import 'package:mobile_ultra/model/payment/pay_params.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/payment/model/bill.dart';
import 'package:mobile_ultra/net/payment/payment_check_presenter.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';
import 'package:mobile_ultra/screens/base/mwwm/system/widgets/open_app_settings_bottom_sheet.dart';
import 'package:mobile_ultra/screens/card/v2/all_cards_for_payment_page.dart';
import 'package:mobile_ultra/screens/main/payments/v2/base_payment_page_state.dart';
import 'package:mobile_ultra/screens/main/payments/v2/payinfo_result_page.dart';
import 'package:mobile_ultra/screens/main/payments/v2/payment_result/payment_result.dart';
import 'package:mobile_ultra/ui_models/app_bar/custom_app_bar.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/card/v2/card_item.dart';
import 'package:mobile_ultra/ui_models/fields/amount.dart';
import 'package:mobile_ultra/ui_models/fields/phone.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet.dart';
import 'package:mobile_ultra/ui_models/rows/provider_row_item.dart';
import 'package:mobile_ultra/ui_models/various/contact_selector.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/ui_models/various/svg_graphics.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/inject.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/widgets/card_select.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sprintf/sprintf.dart';

class FastPaymentWidget extends StatefulWidget {
  static const Tag = '/fastPayment';

  final MerchantEntity merchant;

  const FastPaymentWidget({required this.merchant});

  @override
  State<StatefulWidget> createState() => FastPaymentWidgetState();
}

class FastPaymentWidgetState extends BaseInheritedTheme<FastPaymentWidget>
    with PaymentCheckView, WidgetsBindingObserver {
  Bill? payBill;
  List<MerchantField>? fields;
  AttachedCard? currentCard;
  Map<String, dynamic> requestBody = {};
  Map<String, String> details = {};

  bool showLoading = false, isPaid = false, blockBtn = true;

  final GlobalKey<PhoneFieldState> phoneKey = GlobalKey();
  final FocusNode phoneFocus = FocusNode();

  final GlobalKey<AmountFieldState> amountKey = GlobalKey();
  final FocusNode amountFocus = FocusNode();

  final _amountController = TextEditingController();

  FocusNode? focus;

  String get _amountText => _amountController.text;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setAmountHintAndMaxLength();
    _checkUserSetCardDefault();
  }

  //TODO (Abdurahmon): redo via elementary in the future
  void _checkUserSetCardDefault() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final pynetLocalStorage = inject<Box>();
      final pickedCardId = pynetLocalStorage.get('card_id');
      currentCard = homeData?.cards.firstWhereOrNull((card) {
        return card.id == pickedCardId;
      });
      if (currentCard != null) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _amountController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      focus = FocusScope.of(context).focusedChild;
      focus?.unfocus();
    } else if (state == AppLifecycleState.resumed) {
      Future.delayed(
        Duration(milliseconds: 200),
        () => focus?.requestFocus(),
      );
    }
  }

  @override
  Widget get formWidget {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Scaffold(
            appBar: PynetAppBar('fast_pay_title'),
            body: inputForm,
          ),
          LoadingWidget(showLoading: showLoading),
        ],
      ),
      onWillPop: () async {
        Navigator.pop(
          context,
          isPaid,
        );
        return false;
      },
    );
  }

  Widget get unavailableForm => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextLocale(
              'service_not_available',
              style: TextStyles.headline.copyWith(
                color: ColorNode.Red,
              ),
            ),
            RoundedButton(
              bg: Colors.transparent,
              title: 'close',
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      );

  Widget get inputForm => SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              key: topContainerKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ItemContainer(
                    padding: EdgeInsets.only(
                      top: 12,
                      bottom: 24,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ProviderItem(merchant: widget.merchant),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 16,
                            top: 12,
                            right: 16,
                          ),
                          child: Stack(
                            children: <Widget>[
                              PhoneField(
                                locale.getText('phone_number'),
                                key: phoneKey,
                                focus: phoneFocus,
                                nextFocus: amountFocus,
                                action: TextInputAction.next,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: 4,
                                  ),
                                  child: IconButton(
                                    icon: SvGraphics.icon('contact'),
                                    onPressed: _chooseFromContactList,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: TextLocale(
                      'where',
                      style: TextStyles.captionButton,
                    ),
                  ),
                  SizedBox(height: 8),
                  ItemContainer(
                    child: currentCard == null
                        ? CardSelect.card(
                            onTap: () => _onTapSelectCard(null),
                          )
                        : CardItem(
                            uCard: currentCard!,
                            margin: const EdgeInsets.all(0),
                            onTap: _onTapSelectCard,
                          ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            ItemContainer(
              key: bottomContainerKey,
              borderRadius: BorderRadius.all(Radius.circular(24)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      top: 12,
                      right: 16,
                      bottom: 10,
                    ),
                    child: AmountField(
                      locale.getText('amount'),
                      key: amountKey,
                      bonus: widget.merchant.bonus,
                      controller: _amountController,
                      focus: amountFocus,
                      action: TextInputAction.done,
                      onChanged: _onChangedAmount,
                      onBlockButton: onBlockButton,
                      cashbackExists: currentCard?.type != Const.BONUS,
                    ),
                  ),
                  RoundedButton(
                    margin: EdgeInsets.only(
                      left: 16,
                      top: 12,
                      right: 16,
                      bottom: 16,
                    ),
                    title: locale.getText('continue'),
                    loading: showLoading,
                    onPressed: blockBtn ? null : onCheckFields,
                  )
                ],
              ),
            ),
          ],
        ),
      );

  void onCheckFields() async {
    payBill = null;

    if (phoneKey.currentState?.invalidate ?? true) return;

    if (amountKey.currentState?.invalidate ?? true) return;

    final amount = double.parse(
        amountKey.currentState?.amount.replaceAll(locale.getText('sum'), '') ??
            '');
    if (widget.merchant.minAmount > amount) {
      amountKey.currentState?.setError(
          error: sprintf(locale.getText('min_amount_error'),
              [formatAmount(widget.merchant.minAmount)]));
      return;
    } else if (widget.merchant.maxAmount < amount) {
      amountKey.currentState?.setError(
          error: sprintf(locale.getText('max_amount_error'),
              [formatAmount(widget.merchant.maxAmount)]));
      return;
    }

    setState(() => blockBtn = true);
    FocusScope.of(context).focusedChild?.unfocus();

    if (currentCard != null &&
        (currentCard?.sms ?? false) &&
        currentCard?.status == CardStatus.VALID) {
      onBuildRequest();
      return;
    }

    if (currentCard != null) {
      if (!(currentCard?.sms ?? false)) {
        onShowMessage(locale.getText('sms_inform_inactive'));
      } else {
        if (currentCard?.status != CardStatus.VALID)
          onShowMessage(getCardStatusDescription(currentCard));
      }
    }

    setState(() => blockBtn = false);
  }

  void onBuildRequest() async {
    onShowLoading();

    details.clear();
    requestBody.clear();

    final Map<String, dynamic> params = {};

    final phone = phoneKey.currentState?.value;
    final amount =
        amountKey.currentState?.amount.replaceAll(locale.getText('sum'), '');

    String? parentId;

    fields ??= await db?.getMerchantFields(widget.merchant.id, locale.prefix);

    fields?.removeWhere((field) => field.typeName == 'PREFIX');

    final serviceId =
        fields?.firstWhereOrNull((field) => field.typeName == 'SERVICE_ID');

    if (serviceId != null) {
      final serviceIdFieldValue = serviceId.values?.firstWhereOrNull(
          (value) => value?.prefix == phone?.substring(0, 2));
      params[serviceId.typeName] = serviceIdFieldValue?.fieldValue;

      parentId = '${serviceIdFieldValue?.id}';
    }

    fields
        ?.where((field) => field.parentId == parentId)
        .toList(growable: false)
        .forEach((field) {
      final label = field.label;

      if (field.type == 'C') {
        params[field.typeName] = phone;
        if (label != null && phone != null) {
          details[label] = phone;
        }
      } else if (field.type == 'A') {
        params[field.typeName] = amount;
        if (label != null && amount != null) {
          details[label] = amount;
        }
      }
    });

    requestBody['account'] = phone;
    requestBody['amount'] = amount;
    requestBody['merchantId'] = widget.merchant.id;
    requestBody['merchantName'] = widget.merchant.name;
    requestBody['params'] = params;
    requestBody['checkId'] = widget.merchant.infoServiceId;
    requestBody['payId'] = widget.merchant.paymentServiceId;

    PaymentCheckPresenter.check(this).makeRequest(jsonEncode(requestBody));
  }

  void onShowLoading() => setState(() => showLoading = true);

  void onShowContent() => setState(() => showLoading = false);

  void onShowMessage(String message, {String? title}) => showDialog(
        context: context,
        builder: (BuildContext context) => showMessage(
          context,
          title ?? locale.getText('error'),
          message,
          onSuccess: () => Navigator.pop(context),
        ),
      );

  @override
  void onCheckComplete({Bill? data, String? error}) async {
    blockBtn = false;
    onShowContent();

    if (error != null) {
      onShowMessage(error);
      return;
    }

    payBill = data;

    if (data?.status == 0) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PayinfoResultPage(
            isScrolled: false,
            paymentParams: PaymentParams(
              merchant: widget.merchant,
            ),
            payBill: data,
            jField: JField.None,
            details: details,
            fieldList: fields ?? [],
            invoice: false,
            requestBody: requestBody,
            selectedCard: currentCard,
          ),
        ),
      );

      if (result != null) {
        switch (result) {
          case PaymentResultAction.Close:
            Navigator.pop(context, result);
            break;
          case PaymentResultAction.PayAgain:
            phoneKey.currentState?.clear();
            amountKey.currentState?.clear();

            setState(() {
              payBill = null;
            });
            break;
        }
      }
    } else {
      onShowMessage(payBill?.statusMessage ?? '');
    }
  }

  void _setAmountHintAndMaxLength() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      amountKey.currentState?.updateHint(
          "${formatAmount(widget.merchant.minAmount)} - ${formatAmount(widget.merchant.maxAmount)}");
      amountKey.currentState
          ?.setMaxLength(formatAmount(widget.merchant.maxAmount).length);
    });
  }

  void _chooseFromContactList() async {
    if (!await Permission.contacts.isGranted) {
      final permissionStatus = await Permission.contacts.request();

      if (permissionStatus.isPermanentlyDenied) {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white,
          isDismissible: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          builder: (context) => OpenAppSettingsBottomSheet(
            request: PermissionRequest.contacts(),
            onPressed: openAppSettings,
          ),
        );
      }

      if (!permissionStatus.isGranted) {
        return;
      }
    }
    //TODO (Abdurahmon): redo via elementary in the future
    final result = await viewModalSheet(
      context: context,
      child: ContactSelector(),
    );
    if (result != null && result.isNotEmpty) {
      phoneKey.currentState?.setValue(result);
      amountFocus.requestFocus();
    }
  }

  void _onTapSelectCard(_) async {
    final resultCard = await viewModalSheet(
      context: context,
      backgroundColor: ColorNode.Background,
      child: AllCardsForPaymentPage(card: currentCard),
    );

    if (resultCard != null) {
      setState(() => currentCard = resultCard);
      if (currentCard?.type != Const.BONUS) {
        final pynetLocalStorage = await inject<Box>();
        await pynetLocalStorage.put('card_id', currentCard?.id);
      }

      _checkAmount();
    }
  }

  void _onChangedAmount(String value) {
    _checkAmount();
  }

  void _checkAmount() {
    if (currentCard == null) {
      return;
    }

    if (_amountText.isNotEmpty) {
      final minAmount = widget.merchant.minAmount;
      final maxAmount = widget.merchant.maxAmount;
      final inputAmount = double.parse(
        _amountText.replaceAll(locale.getText('sum'), '').replaceAll(' ', ''),
      );
      blockBtn = true;
      if (inputAmount >= minAmount) {
        if (inputAmount > maxAmount) {
          amountKey.currentState?.setError(
            error: sprintf(
              locale.getText('max_amount_error'),
              [formatAmount(widget.merchant.maxAmount)],
            ),
          );
        } else if (inputAmount > currentCard!.balance!) {
          amountKey.currentState?.insufficientFunds;
        } else {
          amountKey.currentState?.sufficientFunds;
          blockBtn = false;
        }
      }
    } else {
      blockBtn = true;
    }
    setState(() {});
  }

  void onBlockButton() => setState(() => blockBtn = true);
}
