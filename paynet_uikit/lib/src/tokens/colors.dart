import 'package:flutter/material.dart';

class TextColors {
  TextColors._();

  //Основные цвета
  static const Color primary = Color(0xFF181A20);
  static const Color secondary = Color(0xFF6E7279);
  static const Color hint = Color(0xFFC6C9CE);
  static const Color accent = Color(0xFF17A53C);
  static const Color inverted = Color(0xFFFAFAFA);
  static const Color constant = Color(0xFFFFFFFF);

  //Дополнительные цвета
  static const Color link = Color(0xFF2390DE);
  static const Color linkTap = Color(0xFF3671A5);
  static const Color error = Color(0xFFFF3333);
  static const Color warning = Color(0xFFEF9B38);
  static const Color success = Color(0xFFEF9B38);
}

class BackgroundColors {
  //Основные фоны
  static const Color Default = Color(0xFFEAECF0);
  static const Color primary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFFF3F4F9);
  static const Color surfaceLight = Color(0xFFF5F5F5);
  static const Color surfaceDark = Color(0xFF5C6370);
  static const Color modal = Color(0xFFFFFFFF);
  static const Color news = Color(0xFFC8D7E5);

  //Backdrop
  static const Color dark = Color.fromRGBO(70, 78, 92, 0.6);
  static const Color light = Color.fromRGBO(255, 255, 255, 0.8);
}

class ControlColors {
  ControlColors._();

//Фоны кликабельных элементов

  static const Color primaryActive = Color(0xFF17A53C);
  static const Color primaryDisabled = Color(0xFFA2DBB1);
  static const Color primaryTap = Color(0xFF118A31);
  static const Color secondaryActive = Color(0xFFEAECF0);
  static const Color secondaryActiveV2 = Color(0xFFD4D9DF);
  static const Color secondaryDisabled = Color(0xFFF7F7F9);
  static const Color secondaryTap = Color(0xFFE1E4EA);
  static const Color accent = Color(0xFF3E4551);
  static const Color accentDisabled = Color(0xFFD1D1D2);
  static const Color input = Color(0xFFF3F4F9);
}

//используем для категорий платежей (это в истории планируется такое разделение)
class IconAndOtherColors {
  IconAndOtherColors._();

  //Иконки
  static const Color fill = Color(0xFF3E4551);
  static const Color secondary = Color(0xFF6E7279);
  static const Color accent = Color(0xFF17A53C);
  static const Color constant = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFFF3333);
  static const Color warning = Color(0xFFEF9B38);
  static const Color success = Color(0xFF00C247);
  static const Color info = Color(0xFF2390DE);

  //Lines
  static const Color divider = Color(0xFFEAECF0);
  static const Color linesAccent = Color(0xFF17A53C);
}

class PfmColors {
  PfmColors._();

  //Зачисления
  static const Color turquoise = Color(0xFF21A697);
  static const Color green = Color(0xFF64BF70);
  static const Color gray = Color(0xFFA1B6C9);

  //Расходы
  static const Color yellow = Color(0xFFEAC33B);
  static const Color deepPurple = Color(0xFF6B69CC);
  static const Color pink = Color(0xFFCD69AB);
  static const Color lightGreen = Color(0xFF8AB854);
  static const Color coral = Color(0xFFFF6A61);
  static const Color lime = Color(0xFFC2CF42);
  static const Color lilac = Color(0xFF9D50C2);
  static const Color orange = Color(0xFFEC7F21);
  static const Color lightBlue = Color(0xFF7297DF);
  static const Color azure = Color(0xFF4FA3C9);
}

//цвета для привязанных карт
class CardsColors {
  CardsColors._();

  static const Color green = Color(0xFF17A53C);
  static const Color blue = Color(0xFF3671A5);
  static const Color violet = Color(0xFF6B4DC0);
  static const Color gold = Color(0xFFD1A740);
  static const Color orange = Color(0xFFEF9B38);
  static const Color red = Color(0xFFD62929);
  static const Color grey = Color(0xFF35383F);
  static const Color cyan = Color(0xff32b9d5);
  static const Color purple = Color(0xff9033d5);
}
