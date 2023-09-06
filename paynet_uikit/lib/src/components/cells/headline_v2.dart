import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:paynet_uikit/paynet_uikit.dart';

class HeadlineV2 extends StatelessWidget {
  const HeadlineV2({
    Key? key,
    required this.title,
    this.size = HeadlineSize.m,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  HeadlineV2.Chevron({
    required String title,
    HeadlineSize size = HeadlineSize.m,
    VoidCallback? onTap,
    VoidCallback? onChevronTap,
  }) : this(
          title: title,
          size: size,
          onTap: onTap,
          trailing: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onChevronTap,
            child: ActionIcons.chevronRight16
                .copyWith(color: IconAndOtherColors.secondary),
          ),
        );

  HeadlineV2.AddButton({
    required String title,
    HeadlineSize size = HeadlineSize.m,
    VoidCallback? onTap,
    VoidCallback? onAddButtonTap,
  }) : this(
          title: title,
          size: size,
          onTap: onTap,
          trailing: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onAddButtonTap,
            child: IconContainer(
              size: 24,
              color: TextColors.accent,
              child: ActionIcons.plus.copyWith(
                color: IconAndOtherColors.constant,
                height: 16,
                width: 16,
              ),
            ),
          ),
        );

  HeadlineV2.Text({
    required String title,
    required String text,
    TextStyle? textStyle,
    HeadlineSize size = HeadlineSize.m,
    VoidCallback? onTap,
    VoidCallback? onCounterTap,
  }) : this(
          title: title,
          size: size,
          onTap: onTap,
          trailing: Text(
            text,
            style: textStyle ?? Typographies.textRegularSecondary,
          ),
        );

  HeadlineV2.Icon24({
    required String title,
    required SvgPicture icon,
    Color iconColor = IconAndOtherColors.fill,
    HeadlineSize size = HeadlineSize.m,
    VoidCallback? onTap,
  }) : this(
          title: title,
          size: size,
          onTap: onTap,
          trailing: icon.copyWith(
            height: 24,
            width: 24,
            color: iconColor,
          ),
        );

  HeadlineV2.Counter({
    required String title,
    required int count,
    HeadlineSize size = HeadlineSize.m,
    VoidCallback? onTap,
    VoidCallback? onCounterTap,
  }) : this(
          title: title,
          size: size,
          onTap: onTap,
          trailing: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onCounterTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconContainer(
                  size: 24,
                  color: IconAndOtherColors.fill,
                  child: Text(
                    '$count',
                    style: Typographies.captionButtonConstant,
                  ),
                ),
                const SizedBox(width: 4),
                ActionIcons.chevronRight16
                    .copyWith(color: IconAndOtherColors.secondary),
              ],
            ),
          ),
        );

  final String title;

  final HeadlineSize size;

  final Widget? trailing;

  final VoidCallback? onTap;

  TextStyle? _getStyle() {
    switch (size) {
      case HeadlineSize.l:
        return Typographies.title5;
      case HeadlineSize.m:
        return Typographies.headline;
      case HeadlineSize.s:
        return Typographies.textMedium;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12),
      constraints: const BoxConstraints(minHeight: 32),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: _getStyle(),
              ),
            ),
            trailing ?? const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}

enum HeadlineSize {
  /// learge
  l,
  /// middle
  m,
  /// small
  s,
}
