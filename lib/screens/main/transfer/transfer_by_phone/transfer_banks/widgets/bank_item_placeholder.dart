import 'package:flutter/material.dart';

import 'package:mobile_ultra/resource/decorations.dart';
import 'package:mobile_ultra/ui_models/shimmer.dart';

const _titleShimmerWidthRatio = 0.6;
final _logoShimmerSize = 32.0;
final _titleShimmerHeight = 16.0;

class BankItemPlaceholder extends StatelessWidget {
  const BankItemPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ShimmerLoading(
        isLoading: true,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Row(
            children: [
              Container(
                width: _logoShimmerSize,
                height: _logoShimmerSize,
                decoration: Decorations.gradientedCircularDecoration,
              ),
              SizedBox(width: 12),
              Container(
                width:
                    MediaQuery.of(context).size.width * _titleShimmerWidthRatio,
                height: _titleShimmerHeight,
                decoration: Decorations.gradientedDecoration,
              ),
            ],
          ),
        ),
      );
}
