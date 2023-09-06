import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';

import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_details_screen/widgets/transfer_details_text_fields.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/locale_helper.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';
import 'package:mobile_ultra/widgets/text_field/amount/amount_manager.dart';
import 'package:mobile_ultra/widgets/text_field/postfix/postfix_text_field.dart';
import 'package:sprintf/sprintf.dart';

class TransferDetailsCardsSection extends StatelessWidget {
  final String minSum;
  final String rate;
  final String? flagToCountryUrl;

  final GlobalKey? fromFieldKey;
  final AmountFieldManager fromFieldManager;
  final AmountFieldManager toFieldManager;

  final ValidatorCallback? fromAmountValidate;

  final StateNotifier<String?> errorFromState;

  const TransferDetailsCardsSection({
    required this.fromFieldManager,
    required this.toFieldManager,
    required this.minSum,
    required this.rate,
    required this.errorFromState,
    this.fromFieldKey,
    this.flagToCountryUrl,
    this.fromAmountValidate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(builder: (_, LocaleHelper locale) {
      return Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: ColorNode.ContainerColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16,
            bottom: 12,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StateNotifierBuilder<String?>(
                listenableState: errorFromState,
                builder: (_, String? errorText) {
                  return TransferDetailsTextField(
                    key: const Key(WidgetIds.transferAbroadDetailsYourTransfer),
                    fromFieldKey: fromFieldKey,
                    label: locale.getText('you_transfer'),
                    currencyName: locale.getText('som_short'),
                    fieldManager: fromFieldManager,
                    description: sprintf(
                      locale.getText('abroad_field_from_description_min_sum'),
                      [minSum],
                    ),
                    errorText: errorText,

                    /// TODO получат с бэка
                    countryName: 'USZ',
                    isAutofocus: true,
                    countryFlagUri: Assets.icFlagUzbekistan,
                    amountValidate: fromAmountValidate,
                  );
                },
              ),
              const SizedBox(height: 24),
              TransferDetailsTextField(
                key: const Key(WidgetIds.transferAbroadDetailsTransferTo),
                label: locale.getText('to_transfer'),
                currencyName: locale.getText('tenge_short'),
                fieldManager: toFieldManager,
                description: sprintf(
                  locale.getText('abroad_field_to_description_rate_tng'),
                  [rate],
                ),

                /// TODO получат с бэка
                countryName: 'KZT',
                countryFlagUri: flagToCountryUrl,
              ),
            ],
          ),
        ),
      );
    });
  }
}
