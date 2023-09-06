import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/widgets/most_used_merchant_widget.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

const _naturalGasMerchantId = 708;
const _electricPowerMerchantId = 481;
const _uzonlineMerchantId = 3390;
const _uzonlineMerchantName = 'Uzonline\n';

class MostUsedMerchants extends StatelessWidget {
  final VoidCallback onPressServicePaymentButton;
  final Function(int) onPressMostUsedMerchant;

  const MostUsedMerchants({
    Key? key,
    required this.onPressServicePaymentButton,
    required this.onPressMostUsedMerchant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
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
              onTap: onPressServicePaymentButton,
              child: Ink(
                child: Row(
                  children: [
                    Text(
                      locale.getText('service_payment'),
                      style: TextStyles.headline,
                    ),
                    const Spacer(),
                    SizedBox(width: 12),
                    SvgPicture.asset(
                      Assets.chevronRightRounded,
                      color: ColorNode.MainSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MostUsedMerchantWidget(
                merchantId: _naturalGasMerchantId,
                merchantName: locale.getText('natural_gas'),
                onPressMostUsedMerchant: onPressMostUsedMerchant,
              ),
              MostUsedMerchantWidget(
                merchantId: _electricPowerMerchantId,
                merchantName: locale.getText('electric_power'),
                onPressMostUsedMerchant: onPressMostUsedMerchant,
              ),
              MostUsedMerchantWidget(
                merchantId: _uzonlineMerchantId,
                merchantName: _uzonlineMerchantName,
                onPressMostUsedMerchant: onPressMostUsedMerchant,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
