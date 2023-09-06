import 'package:flutter/material.dart';

import 'package:mobile_ultra/utils/color_scheme.dart';

//https://www.figma.com/file/KcJuz8xNRrzLGqP1lhEDTX/Tokens?node-id=162%3A340
class TextStyles {
  TextStyles._();

  //Счета, селекторы, текстовые ячейки
  static final TextStyle title1 = TextStyle(
    fontSize: 32.0,
    height: (36 / 32),
    fontWeight: FontWeight.w700,
    color: ColorNode.Dark1,
  );

  //Заголовок группы списка текстовых ячеек
  static final TextStyle headline = TextStyle(
    fontSize: 18.0,
    height: (24 / 18),
    fontWeight: FontWeight.w700,
    color: ColorNode.Dark1,
  );

  //Контролы, кнопки, текстовые ячейки
  static final TextStyle textRegular = TextStyle(
    fontSize: 16,
    height: 20 / 16,
    fontWeight: FontWeight.w400,
    color: ColorNode.Dark1,
  );

  static final TextStyle textRegularSecondary =
      textRegular.copyWith(color: ColorNode.MainSecondary);

  static final TextStyle textMedium = TextStyle(
    fontSize: 16.0,
    height: 1.25,
    fontWeight: FontWeight.w500,
    color: ColorNode.Dark1,
  );

  static final TextStyle textBold = TextStyle(
    fontSize: 16,
    height: (20 / 16),
    fontWeight: FontWeight.w700,
    color: ColorNode.Dark1,
  );

  static final TextStyle captionButton = TextStyle(
    fontSize: 14.0,
    height: 16 / 14,
    fontWeight: FontWeight.w500,
    color: ColorNode.Dark1,
  );

  static final TextStyle captionButtonSecondary =
      captionButton.copyWith(color: ColorNode.MainSecondary);

  static final TextStyle captionButtonConstant =
      captionButton.copyWith(color: ColorNode.constant);

  static final TextStyle caption1 = TextStyle(
    fontSize: 14.0,
    height: (16 / 14),
    fontWeight: FontWeight.w400,
    color: ColorNode.Dark1,
  );

  static final TextStyle caption1Bold =
      caption1.copyWith(fontWeight: FontWeight.w700);

  static final TextStyle caption1Medium = TextStyle(
    fontSize: 14.0,
    height: (16 / 14),
    fontWeight: FontWeight.w500,
    color: ColorNode.Dark1,
  );

  static final TextStyle caption1MediumWhite =
      caption1.copyWith(color: ColorNode.ContainerColor);

  static final TextStyle caption1MainSecondary =
      caption1.copyWith(color: ColorNode.MainSecondary);

  static final TextStyle caption1Success =
      caption1.copyWith(color: ColorNode.success);

  static final TextStyle caption1Red = caption1.copyWith(color: ColorNode.Red);

  static final TextStyle caption1Dark3 =
      caption1.copyWith(color: ColorNode.Dark3);

  static final TextStyle caption1White =
      caption1.copyWith(color: ColorNode.ContainerColor);

  static final TextStyle caption2 = TextStyle(
    fontSize: 12.0,
    height: (16 / 12),
    fontWeight: FontWeight.w400,
    color: ColorNode.Dark1,
  );

  static final TextStyle caption2Secondary =
      caption2.copyWith(color: ColorNode.MainSecondary);

  static final TextStyle caption2SemiBold = TextStyle(
    fontSize: 12.0,
    height: (16 / 12),
    fontWeight: FontWeight.w600,
    color: ColorNode.Dark1,
  );

  static final TextStyle title3 = TextStyle(
    fontSize: 26,
    height: (32 / 26),
    fontWeight: FontWeight.w700,
    color: ColorNode.Dark1,
  );

  static final TextStyle title3SemiBold =
      title3.copyWith(fontWeight: FontWeight.w600);

  static final TextStyle title4 = TextStyle(
    fontSize: 22,
    height: (28 / 22),
    fontWeight: FontWeight.w700,
    color: ColorNode.Dark1,
  );

  static final TextStyle title5 = TextStyle(
    fontSize: 20,
    height: 24 / 20,
    fontWeight: FontWeight.w700,
    color: ColorNode.Dark1,
  );

  static final TextStyle textInput = TextStyle(
    fontSize: 18.0,
    height: (22 / 18),
    fontWeight: FontWeight.w400,
    color: ColorNode.Dark1,
  );

  static final TextStyle textInputMainSecondary = textInput.copyWith(
    color: ColorNode.MainSecondary,
  );

  static final TextStyle textInputRed = textInput.copyWith(
    color: ColorNode.Red,
  );

  static final TextStyle textInputBold = TextStyle(
    fontSize: 18.0,
    height: (22 / 18),
    fontWeight: FontWeight.w700,
    color: ColorNode.Dark1,
  );

  static final TextStyle textInputBoldRed = textInputBold.copyWith(
    color: ColorNode.Red,
  );

  static final TextStyle textInputHint = TextStyle(
    fontSize: 18.0,
    height: (22 / 18),
    fontWeight: FontWeight.w400,
    color: ColorNode.Hint,
  );

  static final TextStyle textInputBoldHint = TextStyle(
    fontSize: 18.0,
    height: (22 / 18),
    fontWeight: FontWeight.w700,
    color: ColorNode.Hint,
  );

  static final TextStyle title2 = TextStyle(
    fontSize: 28.0,
    height: (36 / 32),
    fontWeight: FontWeight.w500,
    color: ColorNode.Dark1,
  );
}

class TextStylesX {
  TextStylesX._();

  //Счета, селекторы, текстовые ячейки
  static final TextStyle title1 = TextStyle(
    fontSize: 32.0,
    height: 36 / 32,
    fontWeight: FontWeight.w700,
    color: ColorNode.Dark1,
  );

  //Заголовок группы списка текстовых ячеек
  static final TextStyle headline = TextStyle(
    fontSize: 18.0,
    height: 24 / 18,
    fontWeight: FontWeight.w700,
    color: ColorNode.Dark1,
  );

  //Контролы, кнопки, текстовые ячейки
  static final TextStyle textRegular = TextStyle(
    fontSize: 16,
    height: 20 / 16,
    fontWeight: FontWeight.w400,
    color: ColorNode.Dark1,
  );

  static final TextStyle textRegularSecondary =
      textRegular.copyWith(color: ColorNode.MainSecondary);

  static final TextStyle textMedium = TextStyle(
    fontSize: 16.0,
    height: 20 / 16,
    fontWeight: FontWeight.w500,
    color: ColorNode.Dark1,
  );

  static final TextStyle textBold = TextStyle(
    fontSize: 16,
    height: 20 / 16,
    fontWeight: FontWeight.w700,
    color: ColorNode.Dark1,
  );

  static final TextStyle captionButton = TextStyle(
    fontSize: 14.0,
    height: 16 / 14,
    fontWeight: FontWeight.w500,
    color: ColorNode.Dark1,
  );

  static final TextStyle captionButtonSecondary =
      captionButton.copyWith(color: ColorNode.MainSecondary);

  static final TextStyle captionButtonConstant =
      captionButton.copyWith(color: ColorNode.constant);

  static final TextStyle caption1 = TextStyle(
    fontSize: 14.0,
    height: 16 / 14,
    fontWeight: FontWeight.w400,
    color: ColorNode.Dark1,
  );

  static final TextStyle caption1Bold =
      caption1.copyWith(fontWeight: FontWeight.w700);

  static final TextStyle caption1Medium = TextStyle(
    fontSize: 14.0,
    height: 16 / 14,
    fontWeight: FontWeight.w500,
    color: ColorNode.Dark1,
  );

  static final TextStyle caption1MediumWhite =
      caption1.copyWith(color: ColorNode.ContainerColor);

  static final TextStyle caption1MainSecondary =
      caption1.copyWith(color: ColorNode.MainSecondary);

  static final TextStyle caption1Success =
      caption1.copyWith(color: ColorNode.success);

  static final TextStyle caption1Red = caption1.copyWith(color: ColorNode.Red);

  static final TextStyle caption1Dark3 =
      caption1.copyWith(color: ColorNode.Dark3);

  static final TextStyle caption1White =
      caption1.copyWith(color: ColorNode.ContainerColor);

  static final TextStyle caption2 = TextStyle(
    fontSize: 12.0,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
    color: ColorNode.Dark1,
  );

  static final TextStyle caption2Secondary =
      caption2.copyWith(color: ColorNode.MainSecondary);

  static final TextStyle caption2SemiBold = TextStyle(
    fontSize: 12.0,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    color: ColorNode.Dark1,
  );

  static final TextStyle title3 = TextStyle(
    fontSize: 26,
    height: 32 / 26,
    fontWeight: FontWeight.w700,
    color: ColorNode.Dark1,
  );

  static final TextStyle title3SemiBold =
      title3.copyWith(fontWeight: FontWeight.w600);

  static final TextStyle title4 = TextStyle(
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w700,
    color: ColorNode.Dark1,
  );

  static final TextStyle title5 = TextStyle(
    fontSize: 20,
    height: 24 / 20,
    fontWeight: FontWeight.w700,
    color: ColorNode.Dark1,
  );

  static final TextStyle textInput = TextStyle(
    fontSize: 18.0,
    height: 22 / 18,
    fontWeight: FontWeight.w400,
    color: ColorNode.Dark1,
  );

  static final TextStyle textInputMainSecondary = textInput.copyWith(
    color: ColorNode.MainSecondary,
  );

  static final TextStyle textInputRed = textInput.copyWith(
    color: ColorNode.Red,
  );

  static final TextStyle textInputBold = TextStyle(
    fontSize: 18.0,
    height: 22 / 18,
    fontWeight: FontWeight.w700,
    color: ColorNode.Dark1,
  );

  static final TextStyle textInputBoldRed = textInputBold.copyWith(
    color: ColorNode.Red,
  );

  static final TextStyle textInputHint = TextStyle(
    fontSize: 18.0,
    height: 22 / 18,
    fontWeight: FontWeight.w400,
    color: ColorNode.Hint,
  );

  static final TextStyle textInputBoldHint = TextStyle(
    fontSize: 18.0,
    height: 22 / 18,
    fontWeight: FontWeight.w700,
    color: ColorNode.Hint,
  );

  static final TextStyle title2 = TextStyle(
    fontSize: 28.0,
    height: 36 / 32,
    fontWeight: FontWeight.w500,
    color: ColorNode.Dark1,
  );
}
