import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/currency_input_bottom_sheet/route/arguments.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/currency_input_bottom_sheet/route/route.dart';
import 'package:mobile_ultra/ui_models/toast/toast.dart';
import 'package:mobile_ultra/widgets/cell_phone_payment/cell_phone_payment.dart';
import 'package:mobile_ultra/widgets/cell_phone_payment/cell_phone_payment_model.dart';
import 'package:ui_kit/ui_kit.dart';

abstract class ICellPhonePaymentWidgetModel extends IWidgetModel {
  abstract final GlobalKey<PhoneInputState> phoneInputKey;

  abstract final FocusNode focusNode;

  abstract final TextEditingController phoneController;

  String? onValidatePhoneNumberCode(String? text);
}

class CellPhonePaymentWM
    extends WidgetModel<CellPhonePayment, CellPhonePaymentModel>
    implements ICellPhonePaymentWidgetModel {
  CellPhonePaymentWM(super.model);

  @override
  final FocusNode focusNode = FocusNode();

  @override
  final TextEditingController phoneController = TextEditingController();

  @override
  final GlobalKey<PhoneInputState> phoneInputKey = GlobalKey<PhoneInputState>();

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    phoneController.addListener(() async {
      if (_checkIfPhoneNumberIsValid(phoneController.text) == true) {
        FocusManager.instance.primaryFocus?.unfocus();
        final isPaymentSuccessful = await CurrencyInputBottomSheetRoute.show(
          context: context,
          arguments: CurrencyInputBottomSheetArguments(
            phoneNumber: phoneController.text,
            isFastPay: true,
          ),
        );
        if (isPaymentSuccessful == true) {
          _success();
        }
        phoneInputKey.currentState?.formatAndSetValue('');
      }
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  String? onValidatePhoneNumberCode(String? text) {
    if (text == null || _checkIfPhoneNumberIsValid(text) == null) {
      return null;
    } else if (!_checkIfPhoneNumberIsValid(text)!) {
      return locale.getText('no_such_provider');
    }
    return null;
  }

  bool? _checkIfPhoneNumberIsValid(String number) {
    final numberLength = number.replaceAll(' ', "").length;
    if (numberLength != 13) {
      return null;
    }
    final result = getPhoneProvider(number, ignore: [PhoneProvider.Humans]);
    return result != null;
  }

  void _success() {
    Toast.show(
      context,
      title: locale.getText('payment_is_successful'),
      type: ToastType.success,
    );
    widget.onSuccessPayment?.call();
  }
}

CellPhonePaymentWM wmFactory(context) =>
    CellPhonePaymentWM(CellPhonePaymentModel());
