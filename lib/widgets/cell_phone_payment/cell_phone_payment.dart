import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';

import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/widgets/cell_phone_payment/cell_phone_payment_wm.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';
import 'package:paynet_uikit/paynet_uikit.dart';

class CellPhonePayment extends ElementaryWidget<ICellPhonePaymentWidgetModel> {
  const CellPhonePayment({
    Key? key,
    this.onSuccessPayment,
  }) : super(wmFactory, key: key);

  final VoidCallback? onSuccessPayment;

  @override
  Widget build(ICellPhonePaymentWidgetModel wm) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: ColorNode.ContainerColor,
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextLocale(
              'phone_number_payment',
              style: TextStyles.headline,
            ),
          ),
          const SizedBox(height: 4),
          PhoneInput(
            key: wm.phoneInputKey,
            controller: wm.phoneController,
            focusNode: wm.focusNode,
            validator: wm.onValidatePhoneNumberCode,
          ),
        ],
      ),
    );
  }
}
