import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/widgets/card_input.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/widgets/expiration_input.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:ui_kit/ui_kit.dart';

const _cardContainerHeight = 196.0;

class CardForAddition extends StatelessWidget {
  const CardForAddition({
    required this.cardType,
    required this.selectedCardColor,
    required this.colorsList,
    required this.cardNumberFocusNode,
    required this.cardNumberController,
    required this.cardExpirationDateFocusNode,
    required this.cardExpirationDateController,
    required this.onScanCardTap,
    super.key,
    this.cardExpKey,
    this.cardNumberValidator,
    this.cardNumberKey,
    this.cardExpValidator,
  });

  final CardType? cardType;
  final int selectedCardColor;
  final List<Color> colorsList;
  final FocusNode cardNumberFocusNode;
  final TextEditingController cardNumberController;
  final FocusNode cardExpirationDateFocusNode;
  final TextEditingController cardExpirationDateController;
  final Future<String?> Function() onScanCardTap;
  final GlobalKey? cardNumberKey;
  final FormFieldValidator<String>? cardNumberValidator;
  final GlobalKey? cardExpKey;
  final FormFieldValidator<String>? cardExpValidator;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _cardContainerHeight,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: colorsList[selectedCardColor],
      ),
      child: Stack(
        children: [
          Container(
            width: 327,
            height: 327,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-.35, -.5),
                radius: 2.2,
                colors: <Color>[
                  Colors.white.withOpacity(.1),
                  Colors.transparent,
                ],
                stops: const <double>[.4, .4],
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 16),
              Container(
                key: const Key(WidgetIds.cardAdditionNumber),
                child: CardInput(
                  key: cardNumberKey,
                  autofocus: true,
                  focusNode: cardNumberFocusNode,
                  controller: cardNumberController,
                  hintText: locale.getText('card_number'),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  onScanCardTap: onScanCardTap,
                  validator: cardNumberValidator,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    key: const Key(WidgetIds.cardAdditionExpDate),
                    width: 139,
                    child: ExpirationInput(
                      key: cardExpKey,
                      focusNode: cardExpirationDateFocusNode,
                      controller: cardExpirationDateController,
                      hintText: locale.getText('mm_yy'),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      validator: cardExpValidator,
                    ),
                  ),
                  if (cardType == CardType.Humo || cardType == CardType.Uzcard)
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12,
                        right: 16,
                      ),
                      child: SvgPicture.asset(
                        cardType == CardType.Humo
                            ? Assets.humoTextLogo
                            : Assets.uzcardLogo2,
                        height: cardType == CardType.Humo ? 20 : 40,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
