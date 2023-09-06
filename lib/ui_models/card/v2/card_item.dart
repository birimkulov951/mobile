import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/main.dart' show pref;
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/ui_models/card/v2/mini_card_widget.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/ui_models/various/label.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

const _uzcard = 'uzcard';
const _humo = 'humo';

class CardItem extends StatelessWidget {
  final AttachedCard? uCard;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final bool? isSelected;
  final bool? hideBalance;
  final Color? backgroundColor;
  final ValueChanged<AttachedCard?>? onTap;

  const CardItem({
    Key? key,
    this.uCard,
    this.isSelected,
    this.hideBalance,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      uCard != null ? cardLayout : cardIsNullLayout;

  Widget get cardLayout => ItemContainer(
        margin: margin ?? EdgeInsets.zero,
        backgroundColor: backgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
        child: InkWell(
          onTap: onTap == null ? null : () => onTap?.call(uCard),
          child: Padding(
            padding: padding ??
                const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 16,
                ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MiniCardWidget(uCard: uCard),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              uCard?.name ?? '',
                              style: TextStylesX.textRegularSecondary,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                            ),
                          ),
                          Text(
                            _lastFour(),
                            style: TextStylesX.textRegularSecondary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LocaleBuilder(builder: (_, locale) {
                            return Text(
                              (hideBalance ?? pref?.hideBalance ?? true)
                                  ? '• ••• ${locale.getText('sum')}'
                                  : '${formatAmount(uCard?.balance, isHidden: hideBalance ?? pref?.hideBalance ?? true)} ${locale.getText('sum')}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStylesX.title5,
                            );
                          }),
                          cardStatus,
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12),
                if (onTap != null)
                  isSelected == null
                      ? Icon(
                          Icons.keyboard_arrow_right_rounded,
                          color: ColorNode.MainSecondary,
                        )
                      : isSelected ?? false
                          ? Icon(
                              Icons.check,
                              color: ColorNode.MainSecondary,
                            )
                          : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      );

  Widget get cardIsNullLayout => ItemContainer(
        margin: margin ??
            EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 16,
            ),
        backgroundColor: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          leading: Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: SvgPicture.asset(Assets.fail),
          ),
          title: TextLocale('no_active_cards',
              style: TextStylesX.textRegularSecondary),
          trailing: isSelected == null
              ? Icon(Icons.keyboard_arrow_right)
              : isSelected ?? false
                  ? Icon(Icons.check)
                  : null,
          onTap: onTap == null ? null : () => onTap?.call(uCard),
        ),
      );

  Widget get cardStatus {
    switch (uCard?.status) {
      case CardStatus.EXPIRED:
        return Padding(
          padding: EdgeInsets.only(top: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(Assets.cardExpired),
              Label(
                text: 'expired',
                padding: EdgeInsets.only(left: 8),
                weight: FontWeight.w400,
                color: ColorNode.MainSecondary,
              ),
            ],
          ),
        );
      case CardStatus.BLOCKED:
        return Padding(
          padding: EdgeInsets.only(top: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(Assets.cardBlocked),
              Label(
                text: 'blocked',
                padding: EdgeInsets.only(left: 8),
                weight: FontWeight.w400,
                color: ColorNode.MainSecondary,
              ),
            ],
          ),
        );
      case CardStatus.DISABLED:
        return Padding(
          padding: EdgeInsets.only(top: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(Assets.cardDisabled),
              Label(
                text: 'disabled',
                padding: EdgeInsets.only(left: 8),
                weight: FontWeight.w400,
                color: ColorNode.Yellow,
              ),
            ],
          ),
        );
      case CardStatus.VALID:
        return const SizedBox();
      default:
        return Padding(
          padding: EdgeInsets.only(top: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(Assets.cardInvalid),
              Label(
                text: 'invalid_${uCard?.type == 1 ? _uzcard : _humo}',
                padding: const EdgeInsets.only(left: 8),
                weight: FontWeight.w400,
                color: ColorNode.Red,
              ),
            ],
          ),
        );
    }
  }

  String _lastFour() {
    return ' • ${uCard?.number?.substring((uCard?.number?.length ?? 4) - 4)}';
  }
}
