import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:ui_kit/ui_kit.dart' as uikit;

class BankItem extends StatelessWidget {
  const BankItem({
    Key? key,
    required this.title,
    required this.iconUrl,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final String iconUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: ColorNode.ContainerColor,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: 56,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: SvgPicture.network(
                    iconUrl,
                    width: 32,
                    height: 32,
                    placeholderBuilder: (_) => Icon(
                      Icons.error,
                      size: 32,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyles.textRegular,
                  ),
                ),
                uikit.ActionIcons.chevronRight16,
              ],
            ),
          ),
        ),
      );
}
