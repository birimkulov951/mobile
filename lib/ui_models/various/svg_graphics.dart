import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/main.dart' show appTheme;
import 'package:mobile_ultra/ui_models/buttons/button.dart';

class SvGraphics extends StatelessWidget {
  static const String ASSET = 'assets/graphics/%s.svg';

  final Widget widget;

  SvGraphics.icon(
    String iconName, {
    double size = 24,
    Color? color,
    bool originColor = false,
  }) : widget = SvgIcon(
          iconName: iconName,
          size: size,
          color: color,
          originColor: originColor,
        );

  SvGraphics.indicator(
    String iconName, {
    double size = 24,
    bool? isSelected,
  }) : widget = SvgIndicator(
          iconName: iconName,
          size: size,
          isSelected: isSelected ?? false,
        );

  SvGraphics.button(
    String iconName, {
    double size = 24,
    Color? color,
    bool originColor = false,
    required VoidCallback onPressed,
  }) : widget = SvgButton(
          iconName: iconName,
          size: size,
          color: color,
          originColor: originColor,
          onPressed: onPressed,
        );

  SvGraphics.titleButton({
    required iconName,
    required title,
    Color? color,
    Color? textColor,
    double? size,
    required VoidCallback onPressed,
  }) : widget = SvgTitleButton(
          iconName: iconName,
          title: title,
          size: size,
          color: color,
          textColor: textColor,
          onPressed: onPressed,
        );

  @override
  Widget build(BuildContext context) => widget;
}

class SvgIcon extends StatelessWidget {
  final String iconName;
  final double size;
  final Color? color;
  final bool originColor;

  SvgIcon({
    required this.iconName,
    double? size,
    this.color,
    this.originColor = false,
  }) : size = size ?? 24;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
        SvGraphics.ASSET.replaceAll('%s', iconName),
        width: size,
        height: size,
        color: originColor ? null : color ?? appTheme.iconTheme.color,
      );
}

class SvgIndicator extends StatelessWidget {
  final String iconName;
  final bool isSelected;
  final double size;

  SvgIndicator({
    required this.iconName,
    double? size,
    bool? isSelected,
  })  : size = size ?? 24,
        isSelected = isSelected ?? false;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
      SvGraphics.ASSET.replaceAll('%s', iconName),
      width: size,
      height: size,
      color: isSelected ? appTheme.iconTheme.color : appTheme.indicatorColor);
}

class SvgButton extends SvgIcon {
  final VoidCallback onPressed;

  SvgButton({
    required String iconName,
    double? size,
    Color? color,
    required this.onPressed,
    bool originColor = false,
  }) : super(
          iconName: iconName,
          size: size,
          color: color,
          originColor: originColor,
        );

  @override
  Widget build(BuildContext context) => IconButton(
        icon: super.build(context),
        onPressed: onPressed,
      );
}

class SvgTitleButton extends SvgIcon {
  final String title;
  final Color? textColor;
  final VoidCallback onPressed;

  SvgTitleButton({
    required String iconName,
    double? size,
    Color? color,
    required this.title,
    this.textColor,
    required this.onPressed,
  }) : super(
          iconName: iconName,
          size: size,
          color: color,
        );

  @override
  Widget build(BuildContext context) => RoundedButton(
        icon: super.build(context),
        title: title,
        color: textColor ?? Colors.grey,
        bg: Colors.transparent,
        onPressed: onPressed,
      );
}
