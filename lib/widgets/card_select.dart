import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

/// Виджет для перехода на выбор карт
class CardSelect extends StatelessWidget {
  final EdgeInsets? padding;
  final String imageUrl;
  final String text;
  final VoidCallback? onTap;
  final bool isShowArrow;

  CardSelect({
    Key? key,
    this.padding,
    required this.imageUrl,
    required this.text,
    this.onTap,
    bool? isShowArrow,
  })  : isShowArrow = isShowArrow ?? true,
        super(key: key);

  factory CardSelect.card({
    Key? key,
    EdgeInsets? padding,
    VoidCallback? onTap,
    bool? isShowArrow,
    String? text,
  }) =>
      CardSelect(
        key: key,
        padding: padding ??
            EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 16,
            ),
        imageUrl: Assets.selectCard,
        text: text ?? "select_card",
        onTap: onTap,
        isShowArrow: isShowArrow,
      );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  imageUrl,
                  width: 56,
                  height: 40,
                ),
                const SizedBox(width: 12),
                TextLocale(
                  text,
                  style: TextStyles.textRegularSecondary,
                ),
              ],
            ),
            if (isShowArrow) Icon(Icons.keyboard_arrow_right),
          ],
        ),
      ),
    );
  }
}
