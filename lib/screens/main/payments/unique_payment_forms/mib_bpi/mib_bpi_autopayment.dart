import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_ultra/extensions/iterable_extension.dart';

import 'package:mobile_ultra/main.dart' show locale, appTheme;
import 'package:mobile_ultra/model/payment/merchant_fields.dart';
import 'package:mobile_ultra/net/payment/model/bill.dart';
import 'package:mobile_ultra/screens/base/base_autopayment_form.dart';
import 'package:mobile_ultra/screens/main/payments/auto_payments/autopayment.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/fields/dynamic_field.dart';
import 'package:mobile_ultra/ui_models/various/gnk_objects.dart';
import 'package:mobile_ultra/ui_models/various/svg_graphics.dart';
import 'package:mobile_ultra/ui_models/fields/text.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/ui_models/rows/provider_row_item.dart';

import 'package:mobile_ultra/ui_models/buttons/next_button.dart';
import 'package:mobile_ultra/utils/u.dart';

/// Создание/Редактирование автоплатежа по ГНК
/// arguments:
///     Required[0] - action: create/edit;
///     Required[1] - merchant;
///     Required[2] - reminder or null

class MIBBPIAutoPaymentWidget extends StatefulWidget {
  static const Tag = '/mibBPIAutoPayment';

  @override
  State<StatefulWidget> createState() => MIBBPIAutoPaymentWidgetState();
}

class MIBBPIAutoPaymentWidgetState
    extends BaseAutopaymentForm<MIBBPIAutoPaymentWidget> {
  static const GetObjects = 0;
  static const Inform = 1;

  int _step = GetObjects;
  MerchantField? _field;
  GlobalKey<GNKObjectsWidgetState>? _optionsKey;

  @override
  Widget get getUI => Stack(
        children: <Widget>[
          Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(title ?? ''),
              titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
              actions: <Widget>[
                if (action == AutoPaymentType.Edit)
                  IconButton(
                    icon: SvGraphics.icon('delete'),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => showMessage(
                              context,
                              locale.getText('attention'),
                              locale.getText('confirm_remove_autopayment'),
                              dismissTitle: locale.getText('cancel'),
                              onDismiss: () => Navigator.pop(context),
                              successTitle: locale.getText('delete'),
                              onSuccess: () {
                                Navigator.pop(context);
                                onShowLoading('');
                                //ReminderPresenter.delete(reminder.id, view: this).confirm();
                              }));
                    },
                  )
              ],
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ProviderItem(merchant: merchant),
                  dropdownFieldsContainer,
                  fieldsContainer,
                  Visibility(
                      visible: action == AutoPaymentType.FastPayment,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, top: 10, right: 16),
                            child: CustomTextField(
                              locale.getText('name'),
                              key: keyName,
                              action: TextInputAction.done,
                            ),
                          ),
                          Visibility(
                            visible: Platform.isIOS,
                            child: bySchedule
                                ? Container()
                                : NextButton(
                                    onPress: ({int? checkTo}) =>
                                        onAttemptMakePay(
                                            checkTo:
                                                _step == GetObjects ? 1 : null),
                                    bottom: 5,
                                    right: 14,
                                  ),
                          )
                        ],
                      )),
                  Visibility(
                    visible: bySchedule,
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, top: 10, right: 16),
                          child: GestureDetector(
                            child: Container(
                              color: Colors.transparent,
                              child: IgnorePointer(
                                  ignoring: false,
                                  child: CustomTextField(
                                    locale.getText('payment_date'),
                                    key: keyPeriod,
                                    enable: false,
                                  )),
                            ),
                            onTap: onSelectPeriod,
                          ),
                        ),
                        Visibility(
                            visible: Platform.isIOS &&
                                action != AutoPaymentType.Edit,
                            child: bySchedule
                                ? NextButton(
                                    onPress: ({int? checkTo}) =>
                                        onAttemptMakePay(
                                            checkTo:
                                                _step == GetObjects ? 1 : null),
                                    bottom: 5,
                                    right: 14,
                                  )
                                : Container())
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: Platform.isAndroid && action != AutoPaymentType.Edit,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: RoundedButton(
                  margin: const EdgeInsets.all(16),
                  title: btnTitle ?? '',
                  bg: appTheme.textTheme.bodyText2?.color,
                  color: appTheme.backgroundColor,
                  onPressed: () => onAttemptMakePay(
                      checkTo: _step == GetObjects ? 1 : null)),
            ),
          ),
          LoadingWidget(showLoading: showLoading),
        ],
      );

  @override
  void makeFields(List<dynamic> conditions,
      {bool isNextFocusClick = true, bool clearAccount = true}) {
    super.makeFields(conditions, isNextFocusClick: false, clearAccount: false);

    _step = GetObjects;
    _field = (fieldsContainer.children.removeAt(1) as DynamicField).fieldInfo;

    String? defaultObjectValue;
    if (account != null) defaultObjectValue = account?.payBill?['select'];

    _optionsKey = GlobalKey();
    fieldsContainer.children.insert(
        1,
        GNKObjectsWidget(
          key: _optionsKey!,
          title: _field?.label ?? '',
          onGetObjects: () => onAttemptMakePay(checkTo: 1),
          onDropObjects: () => _step = GetObjects,
          defaultObjectValue: defaultObjectValue ?? '',
        ));

    account = null;
  }

  @override
  Future<String> get getRequestData async {
    switch (_step) {
      case GetObjects:
      case Inform:
        final element = fieldsContainer.children
            .firstWhereOrNull((element) => element is GNKObjectsWidget);

        if (element != null) {
          final Map<String, dynamic> preJsonRequest =
              jsonDecode(await super.getRequestData);
          final Map<String, dynamic> params = preJsonRequest['params'];

          params.putIfAbsent(
              "select", () => _optionsKey?.currentState?.selectedObjectValue);
          _optionsKey?.currentState?.currentInn = params[_field?.typeName];

          requestBody['params'].putIfAbsent('select', () => params['select']);

          if (_step == GetObjects) {
            preJsonRequest['checkId'] = 23010;
            requestBody['checkId'] = 23010;
          }

          return jsonEncode(preJsonRequest);
        } else
          return await super.getRequestData;
      default:
        return await super.getRequestData;
    }
  }

  @override
  void onCheckComplete({Bill? data, String? error}) {
    if (error != null || (data != null && data.status != 0)) {
      super.onCheckComplete(data: data, error: error);
      _step = GetObjects;
      return;
    }

    switch (_step) {
      case GetObjects:
        _step = Inform;

        try {
          final Map<String, dynamic>? details = data?.responseJson == null
              ? null
              : jsonDecode(data!.responseJson!)['details'];

          _optionsKey?.currentState?.onSetOptionList(
              jsonDecode(details?['select']['value'])['options'],
              details?['fio']['value']);
        } on Exception catch (e) {
          _step = GetObjects;
          printLog('select json parse exception: $e');
        }

        onShowContent();
        break;
      case Inform:
        super.onCheckComplete(data: data, error: error);
        break;
    }
  }

  @override
  void onTap(String? typeField, String? value, {bool isAmountWidget = false}) {
    if (typeField == _field?.typeName)
      _optionsKey?.currentState?.onInputINN(value);
  }
}
