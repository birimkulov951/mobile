import 'dart:convert';

import 'package:flutter/material.dart';


import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/net/payment/pynetid_presenter.dart';
import 'package:mobile_ultra/model/payment/pay_params.dart';
import 'package:mobile_ultra/net/payment/model/bill.dart';
import 'package:mobile_ultra/screens/main/payments/accounts/adding_account_result_page.dart';
import 'package:mobile_ultra/ui_models/app_bar/custom_app_bar.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/screens/main/payments/v2/base_payment_page_state.dart';

class AddNewAccountPage extends StatefulWidget {
  final PaymentParams paymentParams;

  const AddNewAccountPage({required this.paymentParams});

  @override
  State<StatefulWidget> createState() => AddNewAccountPageState();
}

class AddNewAccountPageState extends BasePaymentPageState<AddNewAccountPage> {
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
  String get buttonTitle => locale.getText('add');

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
  Widget get cardLayout => SizedBox();

  @override
  Widget get buttonLayout => RoundedButton(
        key: bottomContainerKey,
        margin: EdgeInsets.only(
          left: 16,
          top: 12,
          right: 16,
          bottom: keyboardVisible
              ? MediaQuery.of(context).viewInsets.bottom + 16
              : MediaQuery.of(context).viewPadding.bottom + 16,
        ),
        title: buttonTitle,
        loading: blockBtn,
        onPressed: blockBtn ? null : onAttemptMakePay,
      );

  @override
  void makeFields(List conditions,
      {bool isNextFocusClick = true,
      bool clearAccount = true,
      double topOffset = 0}) {
    super.makeFields(conditions,
        isNextFocusClick: isNextFocusClick,
        clearAccount: clearAccount,
        topOffset: topOffset);

    amountWidget = null;
  }

  @override
  String get getRequestJsonData {
    super.getRequestJsonData;
    requestBody['amount'] = 0;
    requestBody['params']['pay_amount'] = 0;
    return jsonEncode(requestBody);
  }

  @override
  void onCheckComplete({Bill? data, String? error}) async {
    if (error != null) {
      onLoad(load: false);
      onFail(error);
      return;
    }

    payBill = data;

    if (payBill!.status != 0) {
      onLoad(load: false);
      onFail(payBill?.statusMessage);
    } else {
      autoInfoRequest = false;
      _attemptAttachAccount();
    }
  }

  void _attemptAttachAccount() {
    if (payBill?.id == null) {
      return;
    }

    PynetIdPresenter.attachAccount(
        billId: payBill!.id!,
        comment: '',
        onAttachEvent: () async {
          onLoad(load: false);

          Navigator.pop(
            context,
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddingAccountResultPage(),
              ),
            ),
          );
        },
        onError: (error, {errorBody}) {
          onLoad(load: false);
          onFail(error);
        });
  }
}
