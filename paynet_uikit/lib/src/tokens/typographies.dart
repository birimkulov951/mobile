import 'package:flutter/material.dart';
import 'package:paynet_uikit/src/tokens/colors.dart';

//https://www.figma.com/file/KcJuz8xNRrzLGqP1lhEDTX/Tokens?node-id=162%3A340
class Typographies {
  Typographies._();

  static const TextStyle mainTitle = TextStyle(
    fontSize: 36,
    height: 40 / 36,
    fontWeight: FontWeight.w700,
    color: TextColors.primary,
  );

  static const TextStyle title1 = TextStyle(
    fontSize: 32,
    height: 36 / 32,
    fontWeight: FontWeight.w700,
    color: TextColors.primary,
  );

  static const TextStyle title2 = TextStyle(
    fontSize: 28,
    height: 32 / 28,
    fontWeight: FontWeight.w500,
    color: TextColors.primary,
  );
  static final TextStyle title2Error = title2.copyWith(
    color: TextColors.error,
  );

  static final TextStyle title2Hint = title2.copyWith(
    color: TextColors.hint,
  );

  static final TextStyle title2Constant = title2.copyWith(
    color: TextColors.constant,
  );

  static const TextStyle title3 = TextStyle(
    fontSize: 26,
    height: 32 / 26,
    fontWeight: FontWeight.w700,
    color: TextColors.primary,
  );

  static final TextStyle title3Hint = title3.copyWith(
    color: TextColors.hint,
  );

  static const TextStyle title4 = TextStyle(
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w700,
    color: TextColors.primary,
  );

  static const TextStyle title5 = TextStyle(
    fontSize: 20,
    height: 24 / 20,
    fontWeight: FontWeight.w700,
    color: TextColors.primary,
  );

  static const TextStyle headline = TextStyle(
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w700,
    color: TextColors.primary,
  );

  static final TextStyle headlineSemiBold = headline.copyWith(
    fontWeight: FontWeight.w600,
  );

  static final TextStyle headlineSemiBoldHint = headlineSemiBold.copyWith(
    color: TextColors.hint,
  );

  static final TextStyle headlineConstant = headline.copyWith(
    color: TextColors.constant,
  );

  static const TextStyle textRegular = TextStyle(
    fontSize: 16,
    height: 20 / 16,
    fontWeight: FontWeight.w400,
    color: TextColors.primary,
  );

  static final TextStyle textRegularSecondary = textRegular.copyWith(
    color: TextColors.secondary,
  );

  static final TextStyle textRegularAccent = textRegular.copyWith(
    color: TextColors.accent,
  );

  static final TextStyle textRegularError = textRegular.copyWith(
    color: TextColors.error,
  );

  static final TextStyle textMedium = textRegular.copyWith(
    fontWeight: FontWeight.w500,
  );

  static final TextStyle textMediumError = textMedium.copyWith(
    color: TextColors.error,
  );

  static final TextStyle textMediumAccent = textMedium.copyWith(
    color: TextColors.accent,
  );

  static final TextStyle textBold = textRegular.copyWith(
    fontWeight: FontWeight.w700,
  );

  static const TextStyle captionButton = TextStyle(
    fontSize: 14,
    height: 16 / 14,
    fontWeight: FontWeight.w500,
    color: TextColors.primary,
  );

  static final TextStyle captionButtonSecondary = captionButton.copyWith(
    color: TextColors.secondary,
  );

  static final TextStyle captionButtonConstant = captionButton.copyWith(
    color: TextColors.constant,
  );

  static const TextStyle caption1 = TextStyle(
    fontSize: 14,
    height: 16 / 14,
    fontWeight: FontWeight.w400,
    color: TextColors.primary,
  );

  static final TextStyle caption1Constant = caption1.copyWith(
    color: TextColors.constant,
  );

  static final TextStyle caption1Secondary = caption1.copyWith(
    color: TextColors.secondary,
  );

  static final TextStyle caption1Error = caption1.copyWith(
    color: TextColors.error,
  );

  static final TextStyle caption1Warning = caption1.copyWith(
    color: TextColors.warning,
  );

  static final TextStyle caption1Link = caption1.copyWith(
    color: TextColors.link,
  );

  static const TextStyle caption2 = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
    color: TextColors.primary,
  );

  static final TextStyle caption2Secondary = caption2.copyWith(
    color: TextColors.secondary,
  );

  static final TextStyle caption2SemiBold = caption2.copyWith(
    fontWeight: FontWeight.w600,
  );

  static const TextStyle menuTitle = TextStyle(
    fontSize: 11,
    height: 12 / 11,
    fontWeight: FontWeight.w400,
    color: TextColors.primary,
  );

  static final TextStyle menuTitleConstant = menuTitle.copyWith(
    color: TextColors.constant,
  );

  static const TextStyle textInput = TextStyle(
    fontSize: 18,
    height: 22 / 18,
    fontWeight: FontWeight.w400,
    color: TextColors.primary,
  );

  static final TextStyle textInputSecondary = textInput.copyWith(
    color: TextColors.secondary,
  );

  static final TextStyle textInputError = textInput.copyWith(
    color: TextColors.error,
  );

  static final TextStyle textInputBold = textInput.copyWith(
    fontWeight: FontWeight.w700,
  );

  static final TextStyle textInputHint = textInput.copyWith(
    color: TextColors.hint,
  );

  static const TextStyle cashbackTextRegular = TextStyle(
    fontSize: 10,
    height: 12 / 10,
    fontWeight: FontWeight.w400,
    color: TextColors.primary,
  );

  static final TextStyle cashbackTextRegularSecondary =
      cashbackTextRegular.copyWith(
    color: TextColors.secondary,
  );

  static final TextStyle cashbackTextMedium = cashbackTextRegular.copyWith(
    fontWeight: FontWeight.w500,
  );

  static final TextStyle cashbackTextMediumConstant =
      cashbackTextMedium.copyWith(
    color: TextColors.constant,
  );
}
