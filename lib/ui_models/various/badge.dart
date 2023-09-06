import 'package:flutter/material.dart';
import 'package:paynet_uikit/paynet_uikit.dart' as uiKit;

import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

import 'package:mobile_ultra/ui_models/various/shape_circle.dart';

class Badge extends StatelessWidget {
  const Badge({
    Key? key,
    required this.value,
  }) : super(key: key);

  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 24,
      decoration: const BoxDecoration(
        color: uiKit.IconAndOtherColors.fill,
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: Center(
        child: Text(
          '$value',
          style: uiKit.Typographies.captionButton.copyWith(color: uiKit.IconAndOtherColors.constant),
        ),
      ),
    );
  }
}
