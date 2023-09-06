import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

class RowIcon extends StatelessWidget {
  final String icon;

  const RowIcon({
    Key? key,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 33,
      width: 33,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorNode.ContainerColor,
        shape: BoxShape.circle,
      ),
      child: Container(
        height: 32,
        width: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorNode.MainIcon,
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(icon),
      ),
    );
  }
}
