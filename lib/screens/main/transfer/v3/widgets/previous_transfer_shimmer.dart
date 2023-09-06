import 'package:flutter/material.dart';

import 'package:mobile_ultra/resource/decorations.dart';
import 'package:mobile_ultra/ui_models/shimmer.dart';

const _imageShimmerWidth = 56.0;
const _imageShimmerHeight = 40.0;

class PreviousTransferShimmer extends StatelessWidget {
  const PreviousTransferShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ShimmerLoading(
        isLoading: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Container(
                height: 10,
                decoration: Decorations.gradientedDecoration,
              ),
              subtitle: Container(
                height: 10,
                decoration: Decorations.gradientedDecoration,
              ),
              trailing: Container(
                width: 10,
                height: 10,
                decoration: Decorations.gradientedDecoration,
              ),
              leading: Container(
                width: _imageShimmerWidth,
                height: _imageShimmerHeight,
                decoration: Decorations.gradientedDecoration,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
