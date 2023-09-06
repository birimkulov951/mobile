import 'package:flutter/widgets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';

import 'package:mobile_ultra/ui_models/various/base_item_container.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

class ItemIconTextContainer extends BaseItemContainer {
  final Widget icon;
  final String title;

  ItemIconTextContainer({
    required this.icon,
    required this.title,
    required double width,
    required double height,
    Color backgroundColor = ColorNode.Background,
    required VoidCallback onTap,
  }) : super(
            width: width,
            height: height,
            onTap: onTap,
            backgroundColor: backgroundColor);

  @override
  Widget get child => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          Spacer(),
          TextLocale(
            title,
            style: TextStyles.captionButton,
          ),
        ],
      );
}
