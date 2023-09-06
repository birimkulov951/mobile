import 'package:flutter/material.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/resource/decorations.dart';
import 'package:mobile_ultra/ui_models/shimmer.dart';
import 'package:paynet_uikit/paynet_uikit.dart';

const _shimmerLength = 2;
const _imageSize = 46.0;

const _titleHeight = 20.0;
const _leftTitleWidth = 100.0;
const _rightTitleWidth = 120.0;

const _subTitleHeight = 16.0;
const _leftSubTitleWidth = 80.0;
const _rightSubTitleWidth = 40.0;

class MyAccountsShimmer extends StatelessWidget {
  const MyAccountsShimmer({
    required this.onOpenMyAccountsScreen,
    super.key,
  });

  final VoidCallback onOpenMyAccountsScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: const BoxDecoration(
        color: BackgroundColors.primary,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadlineV2.Chevron(
            title: locale.getText('my_accounts'),
            onTap: onOpenMyAccountsScreen,
          ),
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
                          height: _imageSize,
                          width: _imageSize,
                          decoration: Decorations.gradientedCircularDecoration,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 100,
                                    child: Container(
                                      height: _titleHeight,
                                      width: _leftTitleWidth,
                                      decoration:
                                          Decorations.gradientedDecorationSmall,
                                    ),
                                  ),
                                  const Expanded(
                                    flex: 26,
                                    child: SizedBox(),
                                  ),
                                  Expanded(
                                    flex: 120,
                                    child: Container(
                                      height: _titleHeight,
                                      width: _rightTitleWidth,
                                      decoration:
                                          Decorations.gradientedDecorationSmall,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 80,
                                    child: Container(
                                      height: _subTitleHeight,
                                      width: _leftSubTitleWidth,
                                      decoration:
                                          Decorations.gradientedDecorationSmall,
                                    ),
                                  ),
                                  const Expanded(
                                    flex: 126,
                                    child: SizedBox(),
                                  ),
                                  Expanded(
                                    flex: 40,
                                    child: Container(
                                      height: _titleHeight,
                                      width: _rightSubTitleWidth,
                                      decoration:
                                          Decorations.gradientedDecorationSmall,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
  }
}
