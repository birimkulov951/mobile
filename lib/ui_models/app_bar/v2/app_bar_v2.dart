import 'package:flutter/material.dart';
import 'package:paynet_uikit/paynet_uikit.dart' as uiKit;

const _leadingWith = 40.0;

class AppBarV2 extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final VoidCallback onBackTap;

  const AppBarV2({
    super.key,
    required this.title,
    required this.onBackTap,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      centerTitle: false,
      leadingWidth: _leadingWith,
      leading: GestureDetector(
        onTap: onBackTap,
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: uiKit.ActionIcons.navigationLeft
              .copyWith(color: uiKit.IconAndOtherColors.secondary),
        ),
      ),
    );
  }

  @override
  final Size preferredSize;
}
