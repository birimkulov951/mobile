import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';

double _merchantImageSize = 60;

class MostUsedMerchantWidget extends StatelessWidget {
  final int merchantId;
  final String merchantName;
  final Function(int) onPressMostUsedMerchant;

  const MostUsedMerchantWidget({
    Key? key,
    required this.merchantId,
    required this.merchantName,
    required this.onPressMostUsedMerchant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressMostUsedMerchant(merchantId);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: '${Http.URL}pms2/api/v2/merchant/logo/$merchantId',
            width: _merchantImageSize,
            height: _merchantImageSize,
            fit: BoxFit.fill,
            errorWidget: (context, url, error) {
              return SvgPicture.asset(Assets.info);
            },
          ),
          SizedBox(height: 10),
          Text(
            merchantName,
            style: TextStyles.caption2SemiBold,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
