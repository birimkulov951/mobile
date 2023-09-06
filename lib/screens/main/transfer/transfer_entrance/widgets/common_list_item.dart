import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

//used for both transfer method list item and choose country list item
class CommonListItem extends StatelessWidget {
  final String icon;
  final String bodyText;
  final VoidCallback onTap;

  const CommonListItem({
    Key? key,
    required this.icon,
    required this.bodyText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(icon),
          SizedBox(width: 12),
          Text(
            bodyText,
            style: TextStyles.textRegular,
          ),
          const Spacer(),
          Icon(
            Icons.chevron_right,
            color: ColorNode.MainSecondary,
          ),
        ],
      ),
    );
  }
}
