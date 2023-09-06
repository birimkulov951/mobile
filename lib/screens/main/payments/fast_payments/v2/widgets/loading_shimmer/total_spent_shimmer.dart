import 'package:flutter/material.dart';

import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/resource/decorations.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/ui_models/shimmer.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

class TotalSpentShimmer extends StatelessWidget {
  const TotalSpentShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorNode.ContainerColor,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            locale.getText('spent_today'),
            style: TextStyles.caption2,
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
          const Spacer(),
          Shimmer(
            child: ShimmerLoading(
              isLoading: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    decoration: Decorations.gradientedDecoration,
                  ),
                  SizedBox(height: 2),
                  Container(
                    height: 20,
                    width: 50,
                    decoration: Decorations.gradientedDecoration,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
