import 'package:flutter/material.dart';
import 'package:mobile_ultra/resource/decorations.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/widgets/item_padding.dart';
import 'package:mobile_ultra/ui_models/shimmer.dart';

class ReceiverCardPlaceholder extends StatelessWidget {
  const ReceiverCardPlaceholder();
  Widget get _cardIcon {
    return Container(
      decoration: Decorations.gradientedDecoration,
      width: 32,
      height: 24,
    );
  }

  Widget get _title {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          flex: 60,
          child: Container(
            decoration: Decorations.gradientedDecoration,
            height: 20,
          ),
        ),
        Flexible(
          flex: 40,
          child: const SizedBox(),
        ),
      ],
    );
  }

  Widget get _subTitle {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          flex: 40,
          child: Container(
            decoration: Decorations.gradientedDecoration,
            height: 16,
          ),
        ),
        Flexible(
          flex: 60,
          child: const SizedBox(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context);
    return Shimmer(
      child: ShimmerLoading(
        isLoading: true,
        child: ItemPadding(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _cardIcon,
              const SizedBox(width: 12),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: query.size.width),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _title,
                    const SizedBox(height: 4),
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
