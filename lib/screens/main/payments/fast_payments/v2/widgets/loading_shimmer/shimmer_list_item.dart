import 'package:flutter/material.dart';

import 'package:mobile_ultra/resource/decorations.dart';
import 'package:mobile_ultra/ui_models/shimmer.dart';

final _imageShimmerSize = 46.0;

const _titleShimmerWidthRatio = 0.3;
const _subtitleShimmerWidthRatio = 0.24;

const _amountShimmerWidthRatio = 0.26;
const _cardNumAndDateShimmerWidthRatio = 0.28;

final _firstRowShimmerHeight = 20.0;
final _secondRowShimmerHeight = 16.0;

class ShimmerListItem extends StatelessWidget {
  const ShimmerListItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ShimmerLoading(
        isLoading: true,
        child: Row(
          children: [
            Container(
              height: _imageShimmerSize,
              width: _imageShimmerSize,
              decoration: Decorations.gradientedCircularDecoration,
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width *
                      _titleShimmerWidthRatio,
                  height: _firstRowShimmerHeight,
                  decoration: Decorations.gradientedDecoration,
                ),
                SizedBox(height: 4),
                Container(
                  width: MediaQuery.of(context).size.width *
                      _subtitleShimmerWidthRatio,
                  height: _secondRowShimmerHeight,
                  decoration: Decorations.gradientedDecoration,
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width *
                      _amountShimmerWidthRatio,
                  height: _firstRowShimmerHeight,
                  decoration: Decorations.gradientedDecoration,
                ),
                SizedBox(height: 4),
                Container(
                  width: MediaQuery.of(context).size.width *
                      _cardNumAndDateShimmerWidthRatio,
                  height: _secondRowShimmerHeight,
                  decoration: Decorations.gradientedDecoration,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
