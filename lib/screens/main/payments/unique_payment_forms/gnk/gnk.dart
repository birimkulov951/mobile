import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_ultra/extensions/iterable_extension.dart';

import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/model/payment/pay_params.dart';
import 'package:mobile_ultra/net/payment/gnk_services_req_objects_presenter.dart';
import 'package:mobile_ultra/net/payment/model/bill.dart';
import 'package:mobile_ultra/ui_models/app_bar/custom_app_bar.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/ui_models/fields/dynamic_field.dart';
import 'package:mobile_ultra/ui_models/various/gnk_objects.dart';
import 'package:mobile_ultra/screens/main/payments/v2/base_payment_page_state.dart';
import 'package:mobile_ultra/utils/u.dart';

const _payAmountField = 'pay_amount';

/// Государственный Налоговый Комитет
class GNKPaymentWidget extends StatefulWidget {
  static const Tag = '/gnkWidget';

  final PaymentParams? paymentParams;

  const GNKPaymentWidget({
    this.paymentParams,
  });

  @override
  State<StatefulWidget> createState() => GNKPaymentWidgetState();
}

class GNKPaymentWidgetState extends BasePaymentPageState<GNKPaymentWidget> {
  static const GetObjects = 0;
  static const Inform = 1;

  int _step = GetObjects;
  String _filedType = '';
  GlobalKey<GNKObjectsWidgetState>? _optionsKey;

  List<int> _servicesToShowObjectList = [
    3783,
    3787,
    3789,
    3945,
    4047,
    4048,
    4049,
    4050,
    4051,
  ];

  @override
  void initState() {
    this.paymentParams = widget.paymentParams;

    super.initState();
    Future.delayed(
      const Duration(milliseconds: 250),
      () => _downloadServicesRequiresObjects(),
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
            appBar: PaynetAppBar(
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

    int parentId = int.parse(conditions[0]);
    if (_servicesToShowObjectList.firstWhere((id) => id == parentId,
            orElse: () => -1) !=
        -1) {
      _step = GetObjects;
      _filedType = (fieldsContainer.children.first as DynamicField)
              .fieldInfo
              ?.typeName ??
          _filedType;

      String? defaultObjectValue;
      if (account != null) defaultObjectValue = account?.payBill?['select'];

      _optionsKey = GlobalKey();
      fieldsContainer.children.insert(
        1,
        GNKObjectsWidget(
          key: _optionsKey!,
          onGetObjects: () => onAttemptMakePay(checkTo: 1),
          onDropObjects: () => _step = GetObjects,
          defaultObjectValue: defaultObjectValue ?? '',
        ),
      );
      visibleFieldCount++;
    } else {
      _step = Inform;
      _filedType = '';
    }

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
          _optionsKey?.currentState?.currentInn = params[_filedType];

          requestBody['params'].putIfAbsent('select', () => params['select']);

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
            details?['fio']['value'],
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
    if (typeField == _filedType) {
      _optionsKey?.currentState?.onInputINN(value);
    } else if (typeField == _payAmountField) {
      super.onTap(
        typeField,
        value,
        isAmountWidget: true,
      );
    }
  }

  void _downloadServicesRequiresObjects() {
    onLoad();
    GnkServicesReqObjectsPresenter(onError: ({dynamic error}) {
      onLoad(load: false);
      makeDynamicFields();
    }, onGetServices: ({List<int>? services}) {
      onLoad(load: false);
      if (services != null && services.isNotEmpty) {
        _servicesToShowObjectList.clear();
        _servicesToShowObjectList.addAll(services);
      }
      makeDynamicFields();
    }).getServices();
  }
}
