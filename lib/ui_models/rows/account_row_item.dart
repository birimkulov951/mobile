import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/net/payment/model/paynetid.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/ui_models/various/circle_image.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/widgets/balance_widget.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';
import 'package:paynet_uikit/paynet_uikit.dart';

class AccountItem extends StatelessWidget {
  final PaynetId account;
  final bool viewControls;
  final ValueChanged<PaynetId>? onDeleteItem;
  final ValueChanged<PaynetId>? onTap;
  final EdgeInsets padding;
  final EdgeInsets margin;

  const AccountItem({
    required this.account,
    this.viewControls = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.margin = const EdgeInsets.only(bottom: 4),
    this.onDeleteItem,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ItemContainer(
        height: 70,
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        padding: padding,
        margin: margin,
        child: LocaleBuilder(
          builder: (context, locale) {
            return Row(
              children: [
                Visibility(
                  visible: viewControls,
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: SvgPicture.asset(
                          'assets/graphics_redesign/addbox.svg'),
                    ),
                    onTap: () => onDeleteItem?.call(account),
                  ),
                ),
                CircleImage(merchantId: account.merchantId),
                Expanded(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    title: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            account.merchantName ?? '',
                            style: Typographies.textRegular,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        if (account.lastBalance != null)
                          BalanceWidget(
                            amount: account.lastBalance!,
                            amountTextStyle: _balanceTextStyle,
                            suffixTextStyle: _balanceTextStyle,
                          )
                        else
                          Text(
                            locale.getText('no_data'),
                            style: TextStyles.textRegularSecondary,
                          )
                      ],
                    ),
                    subtitle: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            account.account ?? '',
                            style: Typographies.caption2Secondary,
                          ),
                        ),
                        Text(
                          getBalanceTypeDesc(account),
                          style: Typographies.caption2Secondary,
                        ),
                      ],
                    ),
                    onTap: onTap == null ? null : () => onTap?.call(account),
                  ),
                ),
                Visibility(
                  visible: viewControls,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: SvgPicture.asset(
                        'assets/graphics_redesign/reorder.svg'),
                  ),
                ),
              ],
            );
          },
        ),
      );

  TextStyle get _balanceTextStyle => account.lastBalance! < 0
      ? Typographies.textRegularError
      : Typographies.textRegularAccent;
}
