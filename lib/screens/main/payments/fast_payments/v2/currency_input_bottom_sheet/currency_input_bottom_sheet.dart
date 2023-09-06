import 'dart:ui';

import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/currency_input_bottom_sheet/currency_input_bottom_sheet_wm.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/currency_input_bottom_sheet/route/arguments.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/card/v2/card_item.dart';
import 'package:mobile_ultra/widgets/card_select.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';
import 'package:ui_kit/ui_kit.dart' as uikit;
import 'package:ui_kit/ui_kit.dart';

class CurrencyInputBottomSheet
    extends ElementaryWidget<ICurrencyInputBottomSheetWidgetModel> {
  CurrencyInputBottomSheet({required this.arguments})
      : super(currencyInputBottomSheetWidgetModelFactory);

  final CurrencyInputBottomSheetArguments arguments;

  @override
  Widget build(ICurrencyInputBottomSheetWidgetModel wm) {
    return Form(
      key: wm.formKey,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 6),
              Center(
                child: Container(
                  height: 4,
                  width: 36,
                  decoration: BoxDecoration(
                    color: uikit.IconAndOtherColors.divider,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: 12,
                ),
                child: TextLocale(
                  'amount_is_empty',
                  style: uikit.Typographies.title4,
                ),
              ),
              uikit.AmountBigInput(
                amountController: wm.amountBigController,
                focusNode: wm.amountBigFocusNode,
                autofocus: true,
                validator: wm.validator,
                maxLength: 9,
              ),
              uikit.Divider(),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: TextLocale(
                  'who_do_i_pay',
                  style: uikit.Typographies.captionButtonSecondary,
                ),
              ),
              PhoneCell(
                phoneNumber: wm.phoneNumber,
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: TextLocale(
                  'where',
                  style: uikit.Typographies.captionButtonSecondary,
                ),
              ),
              StateNotifierBuilder<AttachedCard>(
                listenableState: wm.selectFromCardState,
                builder: (context, state) {
                  if (state == null) {
                    return CardSelect.card(
                      onTap: () => wm.selectFromCard(isShowBonusCard: true),
                    );
                  }
                  return CardItem(
                    uCard: state,
                    margin: EdgeInsets.zero,
                    onTap: (card) => wm.selectFromCard(isShowBonusCard: true),
                  );
                },
              ),
            ],
          ),
          StateNotifierBuilder<bool>(
              listenableState: wm.buttonAvalableState,
              builder: (context, isEnabled) {
                isEnabled = isEnabled ?? false;
                return Positioned(
                  bottom: wm.bottomPadding,
                  left: 16,
                  right: 16,
                  child: StateNotifierBuilder<bool>(
                    listenableState: wm.isLoading,
                    builder: (context, isLoading) {
                      return RoundedButton(
                        title: 'make_pay',
                        onPressed: isEnabled! ? wm.pay : null,
                        loading: isLoading == true,
                      );
                    },
                  ),
                );
              })
        ],
      ),
    );
  }
}
