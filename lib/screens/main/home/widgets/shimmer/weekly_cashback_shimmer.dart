import 'package:flutter/material.dart';
import 'package:mobile_ultra/resource/decorations.dart';
import 'package:mobile_ultra/resource/gradients.dart';
import 'package:mobile_ultra/ui_models/shimmer.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';
import 'package:paynet_uikit/paynet_uikit.dart';

const _todayCashbackHeight = 12.0;
const _todayCashbackWidth = 38.0;

const _barHeight = 44.0;
const _barWidth = 10.0;

const _itemCount = 7;

class WeeklyCashbackShimmer extends StatelessWidget {
  const WeeklyCashbackShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        color: BackgroundColors.secondary,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              TextLocale(
                'today',
                style: Typographies.cashbackTextRegularSecondary,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 2.0,
                ),
                decoration: const BoxDecoration(
                  color: TextColors.accent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                child: Shimmer(
                  linearGradient: Gradients.placeholderGradientGreen,
                  child: ShimmerLoading(
                    child: Container(
                      height: _todayCashbackHeight,
                      width: _todayCashbackWidth,
                      decoration: Decorations.gradientedDecorationSmall,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          _list,
        ],
      ),
    );
  }
}

Widget get _list {
  final items = <Widget>[];
  for (var i = 0; i < _itemCount; i++) {
    items.add(_item(i));
  }
  return SizedBox(
    height: _barHeight,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items,
    ),
  );
}

Widget _item(int index) {
  return RotatedBox(
    quarterTurns: 2,
    child: Shimmer(
      linearGradient: index == _itemCount - 1
          ? Gradients.placeholderGradientGreen
          : Gradients.placeholderGradient,
      child: ShimmerLoading(
        child: Container(
          height: _barHeight,
          width: _barWidth,
          decoration: Decorations.gradientedDecoration.copyWith(
            borderRadius: const BorderRadius.all(
              Radius.circular(2),
            ),
          ),
        ),
      ),
    ),
  );
}
