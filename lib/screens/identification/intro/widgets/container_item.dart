import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

class ContainerItem extends StatelessWidget {
  final String iconName;
  final String title;
  final String subtitle;
  final Color? iconColor;

  const ContainerItem({
    Key? key,
    required this.iconName,
    required this.title,
    required this.subtitle,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorNode.Background,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: SvgPicture.asset(
                'assets/graphics_redesign/$iconName.svg',
                color: iconColor,
              ),
            ),
            SizedBox(
              width: 14,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: ColorNode.Dark1,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: ColorNode.Green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
