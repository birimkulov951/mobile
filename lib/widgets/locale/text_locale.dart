import 'package:flutter/material.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';

/// TODO сделать над Material Inherited
/// Искать локальзацию по контексту
/// Этот виджет оставить для приема ключей
/// Минимизировать использование TextLocale
///
/// Текст с локализацией
class TextLocale extends StatelessWidget {
  final String keyName;

  final InlineSpan? textSpan;

  final TextStyle? style;

  final TextAlign? textAlign;

  final TextOverflow? overflow;

  final int? maxLines;

  final double? textScaleFactor;

  const TextLocale(
    this.keyName, {
    Key? key,
    this.textSpan,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.textScaleFactor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(
      builder: (_, locale) => Text(
        locale.getText(keyName),
        style: style,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
      ),
    );
  }
}
