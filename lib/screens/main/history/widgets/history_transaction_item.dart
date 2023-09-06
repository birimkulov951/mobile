import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/net/history/modal/tran_type.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/main.dart' show locale;
import 'package:cached_network_image/cached_network_image.dart';

import 'package:mobile_ultra/main.dart' show getAccessToken;
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/utils/const.dart';

import 'package:intl/intl.dart';

const _sizeOfMerchantImage = 46.0;
const _paynetCardIdLeading = 'UZ998';

class HistoryTransactionItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final String? date7;
  final String? merchantHash;
  final String tranType;
  final String pan;
  final String status;
  final dynamic id;
  final String card1;
  final String? fio;
  final String? account;
  final Function()? onTap;

  const HistoryTransactionItem({
    Key? key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.pan,
    required this.date7,
    required this.merchantHash,
    required this.tranType,
    required this.status,
    required this.card1,
    required this.account,
    required this.fio,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        color: ColorNode.ContainerColor,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: 12),
            Row(
              children: [
                Container(
                  height: _sizeOfMerchantImage,
                  width: _sizeOfMerchantImage,
                  decoration: BoxDecoration(
                    color: ColorNode.Background,
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(80),
                    ),
                    child: _transactionItemLeading(),
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
                              p2pTranType(tranType),
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                              style: TextStyles.textRegular,
                            ),
                            SizedBox(height: 4),
                            Text(
                              categoryType(subtitle, account),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
                            tranType != TranType.credit.value
                                ? "-$price"
                                : "+$price",
                            style: TextStyles.textRegular.copyWith(
                              color: priceColor(tranType, status),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            isWallet(pan),
                            style: TextStyles.caption2Secondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  String categoryType(String? pin, String? account) {
    if (tranType == TranType.p2p.value) {
      return locale.getText('outgoing_transaction');
    } else if (merchantHash != null && tranType == TranType.credit.value) {
      return locale.getText('cashback');
    } else if (merchantHash != null && account != null) {
      return account;
    } else if (pin != null && pin != '') {
      return pin;
    }

    return locale.getText('track_payments');
  }

  String p2pTranType(String tranType) {
    if (tranType == TranType.p2p.value) {
      return fio ?? locale.getText('money_p2p');
    }

    late String result;
    List tranTypes = [
      "P2P",
      "XB_P2P",
      "UZCARD_HUMO_P2P",
      "HUMO_HUMO_P2P",
      "HUMO_HUMO_P2P",
      "HUMO_UZCARD_P2P",
      "CARD_TO_WALLET",
      "WALLET_TO_CARD",
      "WALLET_TO_WALLET"
    ];

    for (var i in tranTypes) {
      if (i == tranType || tranType == '') {
        return result = locale.getText('money_p2p');
      } else {
        result = title;
      }
    }
    if (result.isEmpty &&
        status == TranType.ok.value &&
        tranType == TranType.credit.value) {
      return locale.getText('money_transfer');
    }
    return result;
  }

  String isWallet(String pan) {
    final time = DateFormat("HH:mm")
        .format(DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(date7 ?? ''));

    if (pan.replaceRange(4, pan.length, '') == '7777') {
      return locale.getText('my_wallet') + ', $time';
    } else {
      return locale.getText('card') +
          " •${(pan.substring(pan.length - 4, pan.length))}, $time";
    }
  }

  Color priceColor(String tranType, String status) {
    Color priceColor;
    if (status != TranType.ok.value || tranType == TranType.reversal.value) {
      priceColor = ColorNode.Red;
    } else if (tranType == TranType.credit.value) {
      priceColor = ColorNode.Green;
    } else {
      priceColor = ColorNode.Dark3;
    }
    return priceColor;
  }

  Widget _transactionItemLeading() {
    final card1Length = card1.replaceAll(' ', '').length;

    if (tranType == TranType.p2p.value) {
      return SvgPicture.asset(Assets.outgoingTransfer);
    }

    if (tranType == TranType.credit.value) {
      if (pan.contains(_paynetCardIdLeading)) {
        return merchantHash != null
            ? SvgPicture.asset(Assets.cashback)
            : Image.asset(Assets.paynetCard);
      } else if (card1Length == 16) {
        return Padding(
          padding: EdgeInsets.all(10),
          child: SvgPicture.asset(Assets.humoLogo),
        );
      } else if (card1Length > 16 || card1.isEmpty) {
        return Padding(
          padding: EdgeInsets.all(10),
          child: SvgPicture.asset(Assets.uzcardLogo),
        );
      }
    }

    if (tranType == TranType.debit.value) {
      if (merchantHash != null) {
        return CachedNetworkImage(
          imageUrl: '${Http.URL}pms2/api/v2/merchant/logo/$merchantHash',
          httpHeaders: {Const.AUTHORIZATION: getAccessToken()},
          width: _sizeOfMerchantImage,
          height: _sizeOfMerchantImage,
          fit: BoxFit.fill,
          errorWidget: (context, url, error) {
            //определение трансграна. Других вариантов пока что нет
            if (id != null) {
              return SvgPicture.asset(Assets.vendors);
            }
            return SvgPicture.asset(Assets.info);
          },
        );
      } else if (card1Length == 16) {
        return Padding(
          padding: EdgeInsets.all(10),
          child: SvgPicture.asset(Assets.humoLogo),
        );
      } else if (card1Length > 16 || card1.isEmpty) {
        return Padding(
          padding: EdgeInsets.all(10),
          child: SvgPicture.asset(Assets.uzcardLogo),
        );
      }
    }

    return SvgPicture.asset(Assets.info);
  }
}
