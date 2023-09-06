import 'package:flutter/material.dart';
import 'package:mobile_ultra/resource/decorations.dart';
import 'package:mobile_ultra/ui_models/shimmer.dart';

class MerchantPlaceholder extends StatelessWidget {
  const MerchantPlaceholder({
    super.key,
  });

  Widget get _cardIcon {
    return Container(
      decoration: Decorations.gradientedCircularDecoration,
      width: 46,
      height: 46,
    );
  }

  Widget get _title {
    return Row(
      children: [
        Flexible(
          flex: 81,
          child: Container(
            decoration: Decorations.gradientedDecoration,
            height: 22,
          ),
        ),
        const Flexible(
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
          flex: 55,
          child: Container(
            decoration: Decorations.gradientedDecoration,
            height: 16,
          ),
        ),
        const Flexible(
          flex: 45,
          child: SizedBox(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
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
