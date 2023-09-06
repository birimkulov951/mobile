import 'package:flutter/material.dart';
import 'package:mobile_ultra/resource/decorations.dart';
import 'package:mobile_ultra/ui_models/shimmer.dart';

const _titleHeight = 32.0;
const _titleWidth = 120.0;
const _subTitleHeight = 16.0;
const _subTitleWidth = 70.0;

class MonthlyCashbackShimmer extends StatelessWidget {
  const MonthlyCashbackShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ShimmerLoading(
        isLoading: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: _titleHeight,
              width: _titleWidth,
              decoration: Decorations.gradientedDecorationSmall,
            ),
            const SizedBox(height: 2),
            Container(
              height: _subTitleHeight,
              width: _subTitleWidth,
              decoration: Decorations.gradientedDecorationSmall,
            ),
          ],
        ),
      ),
    );
  }
}
