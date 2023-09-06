import 'package:flutter/material.dart';

import 'package:mobile_ultra/main.dart' show appTheme;
import 'package:mobile_ultra/ui_models/various/shape_circle.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

class CategoryRowItem extends StatelessWidget {
  final Widget leading;
  final Color? leadingColor;
  final String title;
  final String? subTitle;
  final EdgeInsets? padding;
  final bool? single;
  final String? bonus;
  final double leadingSize;
  final VoidCallback? onTap;

  CategoryRowItem({
    required this.leading,
    this.leadingColor,
    required this.title,
    this.subTitle,
    this.padding,
    this.onTap,
    this.single = false,
    this.bonus = '',
    this.leadingSize = 40,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: padding,
        leading: CircleShape(
          size: leadingSize,
          child: leading,
          color: leadingColor,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: TextLocale(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -.4),
              ),
            ),
            Visibility(
              visible: bonus?.isNotEmpty ?? false,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Color(0x2036C05D),
                ),
                child: TextLocale(
                  bonus ?? '',
                  style: TextStyle(
                      color: Color(0xFF36C05D),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -.2),
                ),
              ),
            ),
          ],
        ),
        subtitle: subTitle != null
            ? TextLocale(
                subTitle!,
                style: appTheme.textTheme.bodyText1
                    ?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
              )
            : null,
        trailing: single ?? false
            ? null
            : Icon(
                Icons.keyboard_arrow_right,
                color: ColorNode.Dark3,
              ),
        onTap: onTap,
      );
}
