import 'package:flutter/material.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/utils/url_launcher.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart';

class BonusCard extends StatelessWidget {
  final AttachedCard bonusCard;

  const BonusCard({
    required this.bonusCard,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(
      builder: (_, locale) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: BigCard.medium(
                        name: locale.getText('bonus_card'),
                        balance: sprintf(locale.getText('sum_with_amount'),
                            [formatAmount(bonusCard.balance)]),
                        color: ColorUtils.colorSelect[bonusCard.color!]!,
                        logo: Logo.paynet,
                        maskedPan: formatPhoneNumber(bonusCard.phone!),
                      ),
                    ),
                    const SizedBox(height: 44),
                    Text(
                      locale.getText('your_bonus_card'),
                      style: Typographies.title5,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      locale.getText('bonus_card_reason'),
                      style: Typographies.caption1Secondary,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      locale.getText('bonus_card_purpose'),
                      style: Typographies.caption1Secondary,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RoundedButton(
                        title: locale.getText('good'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () async {
                          if (await UrlLauncher.canLaunchUrl(
                              Const.BONUS_TERMS)) {
                            await UrlLauncher.launchUrl(
                              Const.BONUS_TERMS,
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                        child: Text(
                          locale.getText('bonus_card_offer'),
                          style: Typographies.caption1Secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
