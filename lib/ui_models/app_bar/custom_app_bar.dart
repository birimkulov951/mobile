import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

class PaynetAppBar extends StatelessWidget implements PreferredSizeWidget {
  PaynetAppBar(
    this.title, {
    Key? key,
    this.centerTitle = false,
    this.actions,
    this.backgroundColor,
    this.leading,
    this.returningData,
  })  : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  final String title;
  final bool? centerTitle;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Widget? leading;
  final dynamic returningData;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) => AppBar(
        title: TextLocale(
          title,
          style: TextStylesX.title5,
          overflow: TextOverflow.fade,
        ),
        centerTitle: centerTitle,
        titleSpacing: 0,
        automaticallyImplyLeading: true,
        backgroundColor: backgroundColor,
        leading: leading ?? GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pop(context, returningData),
          child: SvgPicture.asset(
            Assets.navigationArrowLeft,
            width: 24,
            height: 24,
            fit: BoxFit.scaleDown,
          ),
        ),
        actions: actions,
      );
}
