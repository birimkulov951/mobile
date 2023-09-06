import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:mobile_ultra/main.dart' show favoriteList, locale, reminderList;
import 'package:mobile_ultra/model/payment/pay_params.dart';
import 'package:mobile_ultra/model/payment/merchant_fields.dart';
import 'package:mobile_ultra/net/payment/model/pynetid.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/ui_models/app_bar/custom_app_bar.dart';
import 'package:mobile_ultra/utils/PaymentType.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/ui_models/fields/dynamic_field.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/templates_page.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/edit_template_widget.dart';
import 'package:mobile_ultra/screens/main/payments/v2/base_payment_page_state.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';

class PayByTemplatePage extends StatefulWidget {
  final PaymentParams paymentParams;

  const PayByTemplatePage({required this.paymentParams});

  @override
  State<StatefulWidget> createState() => _PayByTemplatePageState();
}

class _PayByTemplatePageState extends BasePaymentPageState<PayByTemplatePage> {
  late String? title;

  @override
  void initState() {
    paymentParams = widget.paymentParams;
    title = paymentParams?.title;

    super.initState();
    Future.delayed(
      const Duration(milliseconds: 250),
      () => makeDynamicFields(),
    );
  }

  @override
  String get buttonTitle => locale.getText('pay_now');

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
            appBar: PynetAppBar(
              title ?? '',
              actions: [
                IconButton(
                  key: const Key(WidgetIds.basePaymentSettingsButton),
                  icon: SvgPicture.asset(Assets.noShapeSettings),
                  onPressed: editTemplate,
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

    templateNameField = DynamicField(
        key: GlobalKey<DynamicFieldState>(),
        fieldInfo: MerchantField(
          label: locale.getText('template_name'),
          typeName: 'template_name',
        ),
        action: TextInputAction.done,
        merchant: paymentParams?.merchant,
        backgroundColor: fieldBackgroundColor,
        defaultValue: title,
        forceBlock: !enabledFields);
  }

  Future<void> editTemplate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditTemplateWidget(
          paymentParams: paymentParams?.copy(
            paymentType: PaymentType.EDIT_TEMPLATE,
          ),
        ),
      ),
    );

    if (result != null) {
      switch (result.first) {
        case TemplateEditResult.Changed:
          if (result.last == null) {
            Navigator.pop(context);
            return;
          }

          title = result.last.name;

          account = PynetId(
              account: paymentParams?.templateType == TemplateType.Favorite
                  ? result.last.bill.account
                  : result.last.account,
              payBill: paymentParams?.templateType == TemplateType.Favorite
                  ? result.last.bill.params
                  : result.last.payBill);

          paymentParams = paymentParams?.copy(
            account: account,
            favorite: paymentParams?.templateType == TemplateType.Favorite
                ? result.last
                : null,
            remider: paymentParams?.templateType == TemplateType.Reminder
                ? result.last
                : null,
          );

          if (amountWidget != null) {
            amountWidget!.textController.text =
                result.last.bill.params['amount'];
          }

          makeDynamicFields();
          break;
        case TemplateEditResult.Removed:
          if (paymentParams?.templateType == TemplateType.Favorite) {
            favoriteList.removeWhere((item) => item.id == result.last);
          } else {
            reminderList.removeWhere((item) => item.id == result.last);
          }
          Navigator.pop(context);
          break;
      }
    }
  }
}
