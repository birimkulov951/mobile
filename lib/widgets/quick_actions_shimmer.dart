import 'package:flutter/cupertino.dart';
import 'package:mobile_ultra/resource/decorations.dart';
import 'package:mobile_ultra/resource/gradients.dart';
import 'package:mobile_ultra/ui_models/shimmer.dart';
import 'package:ui_kit/ui_kit.dart' as uikit;

class QuickActionsShimmer extends StatelessWidget {
  const QuickActionsShimmer({
    required this.itemCount,
    super.key,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    const count = 4;

    return Shimmer(
      linearGradient: Gradients.shimmerGradientLight,
      child: ShimmerLoading(
        child: uikit.QuickActionButtonsSliderV2(
          children: List.generate(
            count,
            (index) => uikit.QuickActionBox(
              icon: const DecoratedBox(
                decoration: Decorations.gradientedCircularDecoration,
              ),
              bottom: Container(
                width: 56,
                height: 16,
                decoration: Decorations.gradientedDecorationSmall,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
