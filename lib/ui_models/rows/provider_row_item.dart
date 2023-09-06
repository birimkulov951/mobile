import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/ui_models/rows/provider_bonus_layout.dart';
import 'package:mobile_ultra/ui_models/various/circle_image.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

class ProviderItem extends StatelessWidget {
  final String subtitle;
  final MerchantEntity? merchant;
  final ValueChanged<MerchantEntity?>? onTap;

  ProviderItem({
    Key? key,
    this.subtitle = '',
    this.merchant,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => merchant == null ? isNull : isNotNull;

  Widget get isNull => SizedBox.shrink();

  Widget get isNotNull {
    return ListTile(
      leading: CircleImage(merchantId: merchant?.id),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 5,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              merchant?.name ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.textInput,
            ),
            flex: 1,
          ),
          Visibility(
            visible: merchant?.bonus != 0,
            child: ProviderBonusLayout(
              value: '${merchant?.bonus}%',
            ),
          ),
        ],
      ),
      subtitle: Text(
        merchant?.legalName ?? subtitle,
        style: TextStyles.caption1.copyWith(color: ColorNode.MainSecondary),
      ),
      onTap: onTap != null ? () => onTap?.call(merchant) : null,
    );
  }
}
