import 'package:flutter/material.dart';
import 'package:mobile_ultra/resource/decorations.dart';
import 'package:mobile_ultra/ui_models/shimmer.dart';

const _textShimmerHeight = 32.0;
const _textShimmerWidth = 284.0;

class MyBalanceShimmer extends StatelessWidget {
  const MyBalanceShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ShimmerLoading(
        isLoading: true,
        child: Container(
          height: _textShimmerHeight,
          width: _textShimmerWidth,
          decoration: Decorations.gradientedDecorationSmall,
        ),
      ),
    );
  }
}
