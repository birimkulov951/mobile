import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/net/history/modal/tran_type.dart';
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/ui_models/various/svg_graphics.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/main.dart' show getAccessToken, locale;
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

class PaymentDetailsHeader extends StatelessWidget {
  final num price;
  final String dateTime;
  final String type;
  final String merchantId;
  final String status;
  final dynamic id;

  const PaymentDetailsHeader({
    Key? key,
    required this.id,
    required this.price,
    required this.dateTime,
    required this.type,
    required this.merchantId,
    required this.status,
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
                child: (merchantId != '')
                    ? CachedNetworkImage(
                        imageUrl:
                            '${Http.URL}pms2/api/v2/merchant/logo/$merchantId',
                        httpHeaders: {Const.AUTHORIZATION: getAccessToken()},
                        width: 46,
                        height: 46,
                        fit: BoxFit.fill,
                        errorWidget: (context, url, error) {
                          //определение трансграна. Других вариантов пока что нет
                          if (type == TranType.debit.value &&
                              id != null &&
                              merchantId.isNotEmpty) {
                            return SvgPicture.asset(Assets.vendors);
                          }
                          return SvGraphics.icon(
                            'info',
                            size: 46,
                          );
                        },
                      )
                    : id == null && type == TranType.debit.value
                        ? SvgPicture.asset(Assets.vendorsP2P)
                        : (type == TranType.p2p.value ||
                                type == TranType.credit.value)
                            ? SvgPicture.asset(Assets.vendors)
                            : SvgPicture.asset(Assets.vendorsP2P),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            LocaleBuilder(
              builder: (_, locale) => Text(
                moneyFormat(price) + ' ' + locale.getText('sum'),
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
}
