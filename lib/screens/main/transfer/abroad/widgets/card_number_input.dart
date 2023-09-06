import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';

class CardNumberInput extends StatelessWidget {
  const CardNumberInput({
    Key? key,
    required this.cardInputController,
    required this.cardInputFormatters,
    required this.cardInputSuffixIconNameState,
    required this.onCardInputActionTap,
  }) : super(key: key);

  final TextEditingController cardInputController;
  final List<TextInputFormatter> cardInputFormatters;
  final StateNotifier<String> cardInputSuffixIconNameState;
  final VoidCallback onCardInputActionTap;

  Widget _cardInputSuffix({
    required String cardInputSuffixIconName,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: SvgPicture.asset(
        cardInputSuffixIconName,
      ),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(builder: (context, locale) {
      return TextField(
        controller: cardInputController,
        autofocus: true,
        textInputAction: TextInputAction.done,
        textCapitalization: TextCapitalization.none,
        keyboardType: TextInputType.number,
        style: TextStyles.textInputBold,
        maxLength: 19,
        inputFormatters: cardInputFormatters,
        decoration: InputDecoration(
          labelText: locale.getText('card_number'),
          labelStyle: TextStyles.textInputHint,
          suffixIcon: StateNotifierBuilder<String>(
            listenableState: cardInputSuffixIconNameState,
            builder: (_, iconName) {
              if (iconName == null) {
                return const SizedBox.shrink();
              }
              return _cardInputSuffix(
                cardInputSuffixIconName: iconName,
                onPressed: onCardInputActionTap,
              );
            },
          ),
          counterText: '',
        ),
      );
    });
  }
}
