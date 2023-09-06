import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/history/modal/history.dart';
import 'package:mobile_ultra/net/history/modal/tran_type.dart';
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/main/history/widgets/card_detail_btm_sheet.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:intl/intl.dart';

final _imageSize = 46.0;

class TransactionListItem extends StatelessWidget {
  const TransactionListItem({
    Key? key,
    required this.historyResponse,
  }) : super(key: key);

  final HistoryResponse historyResponse;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: ColorNode.Background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            builder: (_) {
              return CardDetailBtmSheet(
                historyItem: historyResponse,
                hasShareIcon: true,
                hasQr: historyResponse.mobileQrDto != null,
                hasUserCode: true,
              );
            },
          );
        },
        child: Ink(
          color: ColorNode.ContainerColor,
          child: Row(
            children: [
              Container(
                height: _imageSize,
                width: _imageSize,
                decoration: BoxDecoration(
                  color: ColorNode.Background,
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(80),
                  ),
                  child: (historyResponse.merchantHash != '')
                      ? CachedNetworkImage(
                          imageUrl:
                              '${Http.URL}pms2/api/v2/merchant/logo/${historyResponse.merchantHash}',
                          httpHeaders: {Const.AUTHORIZATION: getAccessToken()},
                          width: _imageSize,
                          height: _imageSize,
                          fit: BoxFit.fill,
                          errorWidget: (context, url, error) {
                            return SvgPicture.asset(Assets.vendors);
                          },
                        )
                      : SizedBox(
                          height: _imageSize,
                          width: _imageSize,
                          child: SvgPicture.asset(Assets.vendorsP2P),
                        ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            historyResponse.merchantName ?? '',
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyles.textRegular,
                            overflow: TextOverflow.fade,
                          ),
                          SizedBox(height: 4),
                          Text(
                            historyResponse.account ?? '',
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            style: TextStyles.caption2Secondary,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          price,
                          style: _getPriceTextStyle,
                        ),
                        SizedBox(height: 4),
                        Text(
                          cardWithPanAndDate(historyResponse.pan ?? ''),
                          style: TextStyles.caption2Secondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get price {
    String price =
        "${formatAmount((historyResponse.amount?.toDouble() ?? 0) / 100)} ${locale.getText('sum')}";
    return historyResponse.tranType != TranType.credit.value
        ? "- $price"
        : "+ " "$price";
  }

  String cardWithPanAndDate(String pan) {
    DateTime data =
        DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(historyResponse.date7!);

    return locale.getText('card') +
        " •${(pan.substring(pan.length - 4, pan.length))}, " +
        (DateFormat("HH:mm").format(data));
  }

  Color priceColor(String tranType, String status) {
    Color priceColor;
    if (status != TranType.ok.value || tranType == TranType.reversal.value) {
      priceColor = ColorNode.Red;
    } else {
      priceColor = ColorNode.Dark3;
    }
    return priceColor;
  }

  TextStyle get _getPriceTextStyle => TextStyles.textRegular.copyWith(
      color: priceColor(
          historyResponse.tranType ?? '', historyResponse.status ?? 'ROK'));
}
