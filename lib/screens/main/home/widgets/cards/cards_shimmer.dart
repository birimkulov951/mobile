import 'package:flutter/material.dart';
import 'package:mobile_ultra/resource/decorations.dart';
import 'package:mobile_ultra/ui_models/shimmer.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';
import 'package:paynet_uikit/paynet_uikit.dart' as uiKit;

const _shimmerLength = 2;
const _cardHeight = 40.0;
const _cardWidth = 56.0;
const _cardRadius = 8.0;

const _titleHeight = 20.0;
const _titleWidth = 140.0;

const _subTitleHeight = 24.0;
const _subTitleWidth = 180.0;

class CardsShimmer extends StatelessWidget {
  const CardsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(builder: (_, locale) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: const BoxDecoration(
          color: uiKit.BackgroundColors.primary,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            uiKit.HeadlineV2.AddButton(title: locale.getText('my_cards')),
            ...List.generate(
              _shimmerLength,
              (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Shimmer(
                    child: ShimmerLoading(
                      isLoading: true,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: _cardHeight,
                            width: _cardWidth,
                            decoration: Decorations.gradientedDecoration
                                .copyWith(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(_cardRadius))),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: _titleHeight,
                                width: _titleWidth,
                                decoration: Decorations.gradientedDecoration,
                              ),
                              const SizedBox(height: 2),
                              Container(
                                height: _subTitleHeight,
                                width: _subTitleWidth,
                                decoration: Decorations.gradientedDecoration,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}
