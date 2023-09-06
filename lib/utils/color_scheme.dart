import 'package:flutter/material.dart';

class Dark {
  static const Color Navigation = Color(0xFF111111);
  static const Color ActiveIcon = Color(0xFFFFFFFF);
  static const Color InactiveIcon = Color(0xFF3B3B3B);
  static const Color Dismiss = Color(0x50FFFFFF);
  static const Color Disabled = Color(0xFF3B3B3B);
  static const Color ItemBg = Color(0xFF1F1F1F);
}

class Light {
  static const Color Navigation = Color(0xFFF9F9F9);
  static const Color ActiveIcon = Color(0xFF000000);
  static const Color InactiveIcon = Color(0xFFC9CACD);
  static const Color Dismiss = Color(0x50000000);
  static const Color Disabled = Color(0xFFE0E0E0);
  static const Color Switch = Color(0xFFF5F5F5);
  static const Color ItemBg = Color(0xFFF1F1F1);
}

class ColorNode {
  //Redesign colors
  //TODO (Abdurahmon): to lower case
  static const Color Main = Color(0xFFF3F4F9);
  static const Color constant = Color(0xFFFFFFFF);
  static const Color MainIcon = Color(0xFF464E5C);
  static const Color Background = Color(0xFFEAECF0);
  static const Color MainSecondary = Color(0xFF6E7279);
  static const Color Yellow = Color(0xFFEF9B38);
  static const Color Dark1 = Color(0xFF181A20);
  static const Color Dark3 = Color(0xFF35383F);
  static const Color GreyScale500 = Color(0xFF9E9E9E);
  static const Color GreyScale200 = Color(0xFFEEEEEE);
  static const Color GreyScale400 = Color(0xFFBDBDBD);
  static const Color GreyScale300 = Color(0xFFE0E0E0);
  static const Color GreyScale600 = Color(0xFF757575);
  static const Color GreyScale800 = Color(0xFF424242);
  static const Color Grey5C = Color(0xFF5C5C5C);
  static const Color Green = Color(0xFF17A53C);
  static const Color GreenDisabled = Color(0xFFA2DBB1);
  static const Color Link = Color(0xFF3671A5);
  static const Color Red = Color(0xFFFF3333);
  static const Color Icon = Color(0xFF3D4453);
  static const Color Tab = Color(0xFF464E5C); //todo hex color exists [MainIcon]
  static const Color ContainerColor = Color(0xFFFFFFFF);
  static const Color Dark4 = Color(0xFF434955);
  static const Color Shadow = Color(0xFF4B4F53);
  static const Color TextSecondary = Color(0xFF6D717A);
  static const Color Hint = Color(0xFFC6C9CE);
  static const Color success = Color(0xFF00C247);
  static const Color iconFill = Color(0xFF3E4551);
  static const Color accent = Color(0xFF3E4551);
  static const Color controlSecondaryActive2 = Color(0xFFD4D9DF);
  static const Color darkGreen = Color(0xFF0C9430);
  static const Color cardBrandBg = Color(0xFFF5F5F5);
  static const Color iphoneNativeBackgroundColor = Color(0xFFFDFDFE);

  // ToDo remove others
  static const Color Blue = Color(0xFF456BF0);
  static const Color DarkGray = Color(0xFF3B3B3B);
  static const Color Gray = Color(0xFFC9CACD);
  static const Color Orange = Color(0xFFF2994A);
  static const Color Purple = Color(0xFF7F51E0);

  static const Color DarkBlue = Color(0xFF353842);
  static const Color Circle = Color(0x509E9E9E);
  static const Color Box = Color(0xFFF2F2F2);
  static const Color Item = Color(0xFFF2F2F2);

  static Color? smsFieldBg;
  static Color? cardBg;
  static Color? cardFieldBb;
  static Color? itemBg;
  static Color lineGraphColor = Color(0xFFE84359);

  //static Color newFastPayBg;
  static Color? tranSwitchBg;
  static List<Color> transSwitchBtnBg = List.filled(3, Colors.transparent);
  static List<Color> transSwitchBtnStroke = List.filled(2, Colors.transparent);
  static Color? receiptBg;
  static Color? autoPaymentItemBg;
  static Color? linearProgressColor;
  static Color? customDropdownBackground;
}

void switchColors(Brightness theme) {
  if (theme == Brightness.light) {
    ColorNode.smsFieldBg = Color(0xFFEBEBEB);
    ColorNode.cardBg = Color(0xFFF2F2F2);
    ColorNode.cardFieldBb = Color(0xFFE6E6E6);
    ColorNode.itemBg = Light.ItemBg;

    ColorNode.tranSwitchBg = Light.Switch;

    ColorNode.transSwitchBtnBg[0] = Color(0xFFF2F2F2);
    ColorNode.transSwitchBtnBg[1] = Color(0xFFF3F3F3);
    ColorNode.transSwitchBtnBg[2] = Color(0xFFF4F4F4);

    ColorNode.transSwitchBtnStroke[0] = Color(0xFFFAFAFA);
    ColorNode.transSwitchBtnStroke[1] = Color(0xFFEBEBEB);

    ColorNode.receiptBg = Color(0xFFF2F2F2);
    ColorNode.autoPaymentItemBg = Color(0x02000000);
    ColorNode.linearProgressColor = Color(0xFF36C05D);

    ColorNode.customDropdownBackground = Color(0xFFFFFFFF);
  } else {
    ColorNode.smsFieldBg = Color(0xFF333333);
    ColorNode.cardBg = Color(0xFF333333);
    ColorNode.cardFieldBb = Color(0xFF474747);
    ColorNode.itemBg = Dark.ItemBg;

    ColorNode.tranSwitchBg = Color(0xFF212121);

    ColorNode.transSwitchBtnBg[0] = Color(0xFF242424);
    ColorNode.transSwitchBtnBg[1] = Color(0xFF1D1D1D);
    ColorNode.transSwitchBtnBg[2] = Color(0xFF171717);

    ColorNode.transSwitchBtnStroke[0] = Color(0xFF272727);
    ColorNode.transSwitchBtnStroke[1] = Color(0xFF0B0B0B);

    ColorNode.receiptBg = Color(0xFF000000);
    ColorNode.autoPaymentItemBg = Color(0x10FFFFFF);
    ColorNode.linearProgressColor = Color(0xFFFFFFFF);

    ColorNode.customDropdownBackground = Color(0xFF2A2929);
  }
}
