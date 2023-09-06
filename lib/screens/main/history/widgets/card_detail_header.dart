import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/net/history/modal/tran_type.dart';
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/main.dart' show getAccessToken, locale;
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

const _paynetCardIdLeading = 'UZ998';

class CardDetailHeader extends StatelessWidget {
  final num price;
  final String dateTime;
  final String type;
  final String? merchantHash;
  final String status;
  final dynamic id;
  final String card1;
  final String tranType;
  final String pan;
  final String? fio;


  const CardDetailHeader({
    Key? key,
    required this.id,
    required this.price,
    required this.dateTime,
    required this.type,
    required this.merchantHash,
    required this.status,
    required this.card1,
    required this.tranType,
    required this.pan,
    this.fio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorNode.ContainerColor,
          borderRadius: BorderRadius.all(
            Radius.circular(24),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 38,
            ),
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorNode.Background,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(23),
                ),
                child: _transactionItemLeading(),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            LocaleBuilder(
              builder: (_, locale) => Text(
                formatAmount(price.toDouble()) + ' ' + locale.getText('sum'),
                style: TextStyles.title1.copyWith(
                  color: ColorNode.Dark3,
                ),
              ),
            ),
            SizedBox(height: 4),
            Text(
              dateTime,
              style: TextStyles.caption1MainSecondary,
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: 8,
                    ),
                    child: SvgPicture.asset(
                      status == TranType.ok.value
                          ? Assets.successSmall
                          : Assets.iconProductStatusWar,
                    ),
                  ),
                ),
                TextLocale(
                  status == TranType.ok.value
                      ? locale.getText("operation_complated")
                      : locale.getText("operation_not_complated"),
                  style: TextStyles.caption1.copyWith(
                    color: status == TranType.ok.value
                        ? ColorNode.Green
                        : ColorNode.Red,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
          ],
        ),
      );

  Widget _transactionItemLeading() {
    final card1Length = card1.replaceAll(' ', '').length;

    final p2pTranTypes = [
      TranType.p2p.value,
      TranType.xbP2p.value,
      TranType.uzcardHumo.value,
      TranType.humoHumo.value,
      TranType.uzcardUzcard.value,
      TranType.humoUzcard.value,
    ];

    if (p2pTranTypes.contains(tranType)) {
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
          width: 46,
          height: 46,
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
