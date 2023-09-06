import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/ui_models/rows/provider_row_item.dart';

class PayinfoCategoryItem extends StatelessWidget {
  final MerchantEntity merchant;

  PayinfoCategoryItem(this.merchant);

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          ProviderItem(
            merchant: merchant,
          ),
        ],
      );
}
