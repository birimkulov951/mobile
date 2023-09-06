import 'package:flutter/material.dart';


import 'package:flutter_svg/flutter_svg.dart';

import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/model/payment/pay_params.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/main/payments/accounts/edit_account_widget.dart';
import 'package:mobile_ultra/ui_models/app_bar/custom_app_bar.dart';
import 'package:mobile_ultra/ui_models/various/label_amount.dart';
import 'package:mobile_ultra/utils/PaymentType.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/ui_models/fields/dynamic_field.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/screens/main/payments/v2/base_payment_page_state.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

class PayByAccountPage extends StatefulWidget {
  final PaymentParams paymentParams;

  const PayByAccountPage({required this.paymentParams});

  @override
  State<StatefulWidget> createState() => _PayByAccountPageState();
}

class _PayByAccountPageState extends BasePaymentPageState<PayByAccountPage> {
  bool _accountChangedOrRemoved = false;
  late String title;
  @override
  DynamicField? templateNameField;

  @override
  void initState() {
    paymentParams = widget.paymentParams;
    title = paymentParams?.title ?? "";
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 250),
      () => makeDynamicFields(),
    );
  }

  @override
  String get buttonTitle => locale.getText('continue');

  @override
  bool get enabledFields => false;

  @override
  Color get fieldsLayoutBackgroundColor => ColorNode.Background;

  @override
  Color get fieldBackgroundColor => ColorNode.Background;

  @override
  Widget get formWidget => Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PaynetAppBar(
              title,
              returningData: _accountChangedOrRemoved,
              actions: [
                IconButton(
                  icon: SvgPicture.asset(Assets.noShapeSettings),
                  onPressed: _editAccount,
                ),
              ],
            ),
            body: scrolledForm,
          ),
          LoadingWidget(
            showLoading: blockBtn,
          ),
        ],
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      amountWidget?.key?.currentState?.setEnabledState();
    });
  }

  @override
  List<Widget> get buttonLayoutItems {
    final items = super.buttonLayoutItems;
    items.insert(0, _accountBalanceInfo);
    return items;
  }

  Widget get _accountBalanceInfo => Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextLocale(
                getBalanceTypeDesc(account),
                style: TextStyles.captionButton,
              ),
              SizedBox(height: 8),
              LabelAmount(
                amount: account?.lastBalance ?? 0,
                color: account?.balanceType == 1
                    ? (account?.lastBalance ?? 0) < 0
                        ? ColorNode.Red
                        : ColorNode.Green
                    : ColorNode.Dark1,
                fontSize1: 26,
                fontSize2: 22,
                fontSize3: 26,
                weight: FontWeight.w500,
              ),
              SizedBox(height: 4),
              TextLocale(
                getBalanceDesc(account),
                style: TextStyles.captionButtonSecondary,
              ),
            ],
          ),
        ),
      );

  Future<void> _editAccount() async {
    /*final result = await viewModalSheet<List<dynamic>>(
      context: context,
      backgroundColor: ColorNode.Background,
      child: EditAccountWidget(
        paymentParams: paymentParams.copy(
          paymentType: PaymentType.EDIT_ACCOUNT
        )
      )
    );*/

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditAccountWidget(
          paymentParams:
              paymentParams?.copy(paymentType: PaymentType.EDIT_ACCOUNT),
        ),
      ),
    );

    if (result != null) {
      switch (result.first) {
        case AccountEditResult.Changed:
          _accountChangedOrRemoved = true;
          if (result.last == null) {
            Navigator.pop(context);
            return;
          }

          account = result.last;

          paymentParams = paymentParams?.copy(
            account: account,
          );

          makeDynamicFields();
          break;
        case AccountEditResult.Removed:
          _accountChangedOrRemoved = true;
          Navigator.pop(context, _accountChangedOrRemoved);
          break;
      }
    }
  }
}
