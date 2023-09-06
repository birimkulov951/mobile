import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:mobile_ultra/utils/color_scheme.dart';

class NavigationCategoryItem extends StatelessWidget {
  final int index;
  final String icon;
  final String title;
  final bool selected;
  final ValueChanged<int> onTap;

  NavigationCategoryItem({
    required this.index,
    required this.icon,
    this.title = '',
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: 82,
        height: 56,
        margin: const EdgeInsets.only(top: 4, bottom: 4),
        child: InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                color: selected
                    ? ColorNode.Green
                    : ColorNode.Dark3.withOpacity(.6),
              ),
              Text(
                title,
                style: TextStyle(
                  height: 2,
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                  color: selected
                      ? ColorNode.Dark3
                      : ColorNode.Dark3.withOpacity(.6),
                ),
              ),
            ],
          ),
          onTap: () => onTap(index),
        ),
      );
}
