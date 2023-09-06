import 'dart:convert';

import 'package:flutter/material.dart';


import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/model/payment/pay_params.dart';
import 'package:mobile_ultra/net/payment/model/bill.dart';
import 'package:mobile_ultra/net/payment/pynetid_presenter.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/main/payments/v2/base_payment_page_state.dart';
import 'package:mobile_ultra/ui_models/app_bar/custom_app_bar.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet_dialog.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

enum AccountEditResult {
  Changed,
  Removed,
}

class EditAccountWidget extends StatefulWidget {
  final PaymentParams? paymentParams;

  const EditAccountWidget({required this.paymentParams});

  @override
  State<StatefulWidget> createState() => _EditAccountWidgetState();
}

class _EditAccountWidgetState extends BasePaymentPageState<EditAccountWidget> {
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
  String get buttonTitle => locale.getText('save_changes');

  @override
  bool get enabledFields => true;

  @override
  Widget get formWidget => Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PynetAppBar(
              'edit_account',
            ),
            body: scrolledForm,
          ),
          LoadingWidget(showLoading: blockBtn),
        ],
      );

  @override
  Widget get cardLayout => SizedBox();

  @override
  Widget get buttonLayout => ItemContainer(
        key: bottomContainerKey,
        margin: EdgeInsets.only(
          top: 12,
          bottom: keyboardVisible
              ? MediaQuery.of(context).viewInsets.bottom
              : MediaQuery.of(context).viewPadding.bottom,
        ),
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: buttonLayoutItems,
        ),
      );

  @override
  List<Widget> get buttonLayoutItems {
    final items = super.buttonLayoutItems;
    items.add(buttonDeleteAccount);
    return items;
  }

  Widget get buttonDeleteAccount => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: RoundedButton(
          bg: Colors.transparent,
          child: TextLocale(
            'remove_account',
            style: TextStyles.captionButtonSecondary,
          ),
          onPressed: removeAccount,
        ),
      );

  @override
  void makeFields(
    List conditions, {
    bool isNextFocusClick = true,
    bool clearAccount = true,
    double topOffset = 0,
  }) {
    super.makeFields(
      conditions,
      isNextFocusClick: isNextFocusClick,
      clearAccount: clearAccount,
      topOffset: topOffset,
    );
    amountWidget = null;
  }

  @override
  String get getRequestJsonData {
    super.getRequestJsonData;
    requestBody['amount'] = 0;
    return jsonEncode(requestBody);
  }

  @override
  void onCheckComplete({
    Bill? data,
    String? error,
  }) async {
    if (error != null) {
      onLoad(load: false);
      onFail(error);
      return;
    }
    payBill = data;

    if (payBill?.status != 0) {
      onLoad(load: false);
      onFail(payBill?.statusMessage);
    } else {
      autoInfoRequest = false;
      _attemptEditAccount();
    }
  }

  @override
  void onTap(String? typeField, String? value, {bool isAmountWidget = false}) {
    super.onTap(typeField, value, isAmountWidget: false);
    canPay = true;
    setState(() {});
  }

  void _attemptEditAccount() {
    if (payBill?.id == null || account?.id == null) {
      return;
    }
    PynetIdPresenter.editAccount(
      billId: payBill!.id!,
      id: account!.id!,
      comment: '',
      onEdit: (account) async {
        onLoad(load: false);

        Navigator.pop(
          context,
          [AccountEditResult.Changed, account],
        );
      },
      onError: (error, {errorBody}) {
        onLoad(load: false);
        onFail(error);
      },
    );
  }

  /// Удаление лиц.счёта
  Future<void> removeAccount() async {
    final result = await viewModalSheetDialog(
          context: context,
          title: locale.getText('confirm_delete_account'),
          confirmBtnTitle: locale.getText('delete'),
          confirmBtnTextStyle: TextStyles.textMedium.copyWith(
            color: ColorNode.Red,
          ),
          cancelBtnTitle: locale.getText('cancel'),
        ) ??
        false;

    if (result) {
      onLoad();

      PynetIdPresenter.delete(
        params: ['${account?.merchantId}', '${account?.account}'],
        onDeleteSuccess: () {
          onLoad(load: false);
          Navigator.pop(
            context,
            [AccountEditResult.Removed, account],
          );
        },
        onError: (error, {errorBody}) {
          onLoad(load: false);
          onFail(error);
        },
      );
    }
  }
}
