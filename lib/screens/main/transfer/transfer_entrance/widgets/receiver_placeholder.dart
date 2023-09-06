import 'package:flutter/material.dart';
import 'package:mobile_ultra/resource/decorations.dart';
import 'package:mobile_ultra/ui_models/shimmer.dart';

class ReceiverPlaceholder extends StatelessWidget {
  const ReceiverPlaceholder({
    super.key,
  });

  Widget get _cardIcon {
    return Container(
      decoration: Decorations.gradientedDecoration,
      width: 56,
      height: 40,
    );
  }

  Widget get _title {
    return Row(
      children: [
        Flexible(
          flex: 81,
          child: Container(
            decoration: Decorations.gradientedDecoration,
            height: 20,
            // width: 190,
          ),
        ),
        Flexible(
          flex: 19,
          child: SizedBox(),
        ),
      ],
    );
  }

  Widget get _subTitle {
    return Row(
      children: [
        Flexible(
          flex: 85,
          child: Container(
            decoration: Decorations.gradientedDecoration,
            height: 24,
          ),
        ),
        Flexible(
          flex: 15,
          child: SizedBox(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Shimmer(
        child: ShimmerLoading(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _cardIcon,
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _title,
                    const SizedBox(height: 2),
                    _subTitle,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
