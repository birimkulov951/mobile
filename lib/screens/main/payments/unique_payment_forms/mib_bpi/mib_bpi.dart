import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_ultra/extensions/iterable_extension.dart';

import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/model/payment/merchant_fields.dart';
import 'package:mobile_ultra/model/payment/pay_params.dart';
import 'package:mobile_ultra/net/payment/model/bill.dart';
import 'package:mobile_ultra/ui_models/app_bar/custom_app_bar.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/ui_models/fields/dynamic_field.dart';
import 'package:mobile_ultra/ui_models/various/gnk_objects.dart';
import 'package:mobile_ultra/screens/main/payments/v2/base_payment_page_state.dart';
import 'package:mobile_ultra/utils/u.dart';

/// Проверка задолженности (БПИ)
class MIBBPIWidget extends StatefulWidget {
  static const Tag = '/mibBPIWidget';

  final PaymentParams paymentParams;

  const MIBBPIWidget({required this.paymentParams});

  @override
  State<StatefulWidget> createState() => MIBBPIWidgetState();
}

class MIBBPIWidgetState extends BasePaymentPageState<MIBBPIWidget> {
  static const GetObjects = 0;
  static const Inform = 1;

  int _step = GetObjects;
  MerchantField? _field;
  GlobalKey<GNKObjectsWidgetState>? _optionsKey;

  @override
  void initState() {
    this.paymentParams = widget.paymentParams;

    super.initState();
    Future.delayed(
      const Duration(milliseconds: 250),
      () => makeDynamicFields(),
    );
  }

  @override
  String get buttonTitle => locale.getText('continue');

  @override
  bool get enabledFields => true;

  @override
  Widget get formWidget => Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PynetAppBar(
              paymentParams?.title ?? '',
            ),
            body: scrolledForm,
          ),
          LoadingWidget(
            showLoading: blockBtn,
          ),
        ],
      );

  @override
  void makeFields(
    List<dynamic> conditions, {
    bool isNextFocusClick = true,
    bool clearAccount = true,
    double topOffset = 0,
  }) {
    super.makeFields(conditions,
        isNextFocusClick: false, clearAccount: false, topOffset: 0);

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
      ),
    );

    account = null;
  }

  @override
  String get getRequestJsonData {
    switch (_step) {
      case GetObjects:
      case Inform:
        final element = fieldsContainer.children.firstWhereOrNull(
          (element) => element is GNKObjectsWidget,
        );

        if (element != null) {
          final Map<String, dynamic> preJsonRequest =
              jsonDecode(super.getRequestJsonData);
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
          return super.getRequestJsonData;
      default:
        return super.getRequestJsonData;
    }
  }

  @override
  void onCheckComplete({Bill? data, String? error}) {
    if (error != null || (data != null && data.status != 0)) {
      super.onCheckComplete(data: data, error: error);
      //_step = GetObjects;
      return;
    }

    switch (_step) {
      case GetObjects:
        _step = Inform;

        try {
          final Map<String, dynamic> details = data?.responseJson == null
              ? null
              : jsonDecode(data!.responseJson!)['details'];

          _optionsKey?.currentState?.onSetOptionList(
            jsonDecode(details['select']['value'])['options'],
            null,
          );
        } on Exception catch (e) {
          _step = GetObjects;
          printLog('select json parse exception: $e');
        }

        onLoad(load: false);
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
