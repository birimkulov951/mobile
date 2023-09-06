import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/screens/main/payments/v2/widgets/merchant_items.dart';
import 'package:paynet_uikit/paynet_uikit.dart' as uikit;

class PopularMerchants extends StatelessWidget {
  const PopularMerchants({
    required this.popularMerchantsState,
    required this.onMerchantTap,
    super.key,
  });

  final ValueListenable<List<MerchantEntity>> popularMerchantsState;

  final void Function(MerchantEntity merchant) onMerchantTap;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<MerchantEntity>>(
      valueListenable: popularMerchantsState,
      builder: (context, state, _) {
        if (state.isEmpty) {
          return const SizedBox.shrink();
        }
        return uikit.RoundedContainer(
          title: uikit.HeadlineV2(
            title: locale.getText('popular'),
          ),
          child: MerchantItems(
            merchants: state,
            onMerchantTap: onMerchantTap,
          ),
        );
      },
    );
  }
}
