import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/screens/main/payments/v2/widgets/merchant_items.dart';
import 'package:ui_kit/ui_kit.dart' as uikit;

class LastMerchants extends StatelessWidget {
  const LastMerchants({
    required this.lastMerchantsState,
    required this.onMerchantTap,
    super.key,
  });

  final ValueListenable<List<MerchantEntity>> lastMerchantsState;

  final void Function(MerchantEntity merchant) onMerchantTap;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<MerchantEntity>>(
      valueListenable: lastMerchantsState,
      builder: (context, state, _) {
        if (state.isEmpty) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: uikit.RoundedContainer(
            title:  uikit.HeadlineV2(title: locale.getText('lasts')),
            child: MerchantItems(
              merchants: state,
              onMerchantTap: onMerchantTap,
            ),
          ),
        );
      },
    );
  }
}
