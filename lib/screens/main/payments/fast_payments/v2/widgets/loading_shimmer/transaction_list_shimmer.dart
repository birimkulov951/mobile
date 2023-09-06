import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/widgets/loading_shimmer/shimmer_list_item.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

double _iconSize = 16;

class TransactionListShimmer extends StatelessWidget {
  const TransactionListShimmer({
    Key? key,
    required this.shimmerListLength,
    required this.onPressOpenHistory,
  }) : super(key: key);

  final int shimmerListLength;
  final VoidCallback onPressOpenHistory;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        12,
        12,
        12,
        16,
      ),
      decoration: BoxDecoration(
        color: ColorNode.ContainerColor,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: ColorNode.ContainerColor,
            child: InkWell(
              onTap: onPressOpenHistory,
              child: Ink(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        locale.getText('last_transactions'),
                        style: TextStyles.headline,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    SizedBox(
                      height: _iconSize,
                      width: _iconSize,
                      child: SvgPicture.asset(Assets.chevronRightRounded),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          ListView.separated(
            separatorBuilder: (_, __) => SizedBox(height: 24),
            itemBuilder: (_, index) => const ShimmerListItem(),
            itemCount: shimmerListLength,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ],
      ),
    );
  }
}
