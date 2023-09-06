import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/ui_models/various/circle_image.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:paynet_uikit/paynet_uikit.dart' as uikit;

class MerchantItems extends StatelessWidget {
  const MerchantItems({
    required this.merchants,
    required this.onMerchantTap,
    super.key,
  });

  final List<MerchantEntity> merchants;
  final void Function(MerchantEntity merchant) onMerchantTap;

  Iterable<Widget> get merchantItems sync* {
    for (int i = 0; i < merchants.length; i++) {
      final merchant = merchants[i];
      yield GestureDetector(
        key: Key('${WidgetIds.paymentsMerchantsList}_$i'),
        behavior: HitTestBehavior.opaque,
        onTap: () => onMerchantTap(merchant),
        child: uikit.VenderCell(
          icon: CircleImage(merchantId: merchant.id),
          title: merchant.name,
          descriptor: merchant.legalName,
          atomSmall: merchant.bonus > 0 ? '${merchant.bonus}%' : null,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...merchantItems,
      ],
    );
  }
}
