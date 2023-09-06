import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ui_kit/ui_kit.dart';

class CardCell extends BasicCell {
  CardCell({
    required this.cardIcon,
    required this.cardName,
    bool isOpaque = true,
    this.cardNameTrailing,
    this.cardBalance,
    this.cardCurrency,
    String? statusText,
    SvgPicture? statusIcon,
    Color? statusColor,
    this.action,
  })  : this.statusText = statusText,
        this.statusIcon = statusIcon?.copyWith(color: statusColor),
        super(
          leading: cardIcon,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                  child: Text(
                cardName,
                style: Typographies.textRegularSecondary,
                overflow: TextOverflow.fade,
                softWrap: false,
              )),
              Text(
                cardNameTrailing ?? '',
                style: Typographies.textRegularSecondary,
              )
            ],
          ),
          subTitle: cardBalance != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      cardBalance,
                      style: Typographies.headlineSemiBold,
                      overflow: TextOverflow.fade,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$cardCurrency',
                      style: Typographies.headlineSemiBoldHint,
                    ),
                  ],
                )
              : null,
          helper: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (statusIcon != null) ...[
                statusIcon.copyWith(color: statusColor),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  statusText ?? '',
                  style: Typographies.caption1Secondary
                      .copyWith(color: statusColor),
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          trailing: action,
          padding: const EdgeInsets.symmetric(vertical: 12),
          isOpaque: isOpaque,
        );

  CardCell.Chevron({
    Key? key,
    required Widget cardIcon,
    required String cardName,
    bool isOpaque = true,
    String? cardCurrency,
    String? cardNameTrailing,
    String? cardBalance,
    String? cardStatusText,
    SvgPicture? cardStatusIcon,
    VoidCallback? onTapChevron,
    Color? statusColor,
  }) : this(
            cardIcon: cardIcon,
            cardName: cardName,
            cardNameTrailing: cardNameTrailing,
            cardBalance: cardBalance,
            statusIcon: cardStatusIcon,
            statusText: cardStatusText,
            cardCurrency: cardCurrency,
            statusColor: statusColor,
            isOpaque: isOpaque,
            action: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTapChevron,
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: ActionIcons.chevronRight16),
            ));

  final Widget cardIcon;
  final String cardName;
  final String? cardNameTrailing;
  final String? cardBalance;
  final String? cardCurrency;
  final Widget? action;
  final String? statusText;
  final SvgPicture? statusIcon;

  @override
  Widget getHelper() {
    if (statusIcon != null || statusText != null) {
      return super.getHelper();
    }
    return const SizedBox.shrink();
  }

  @override
  Widget getBodySpace() {
    return const SizedBox(height: 2);
  }
}

class CardNoBalanceCell extends BasicCell {
  CardNoBalanceCell({
    required this.cardIcon,
    required this.cardName,
    String? statusText,
    SvgPicture? statusIcon,
    Color? statusColor,
    bool isOpaque = true,
    this.action,
    this.cardNameTrailing,
    this.cardNumber,
  })  : this.statusText = statusText,
        this.statusIcon = statusIcon?.copyWith(color: statusColor),
        super(
          leading: cardIcon,
          title: Text(
            cardName,
            style: Typographies.textRegularSecondary,
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
          subTitle: cardNumber != null
              ? Text(
                  cardNumber,
                  style: Typographies.headlineSemiBold,
                  overflow: TextOverflow.fade,
                )
              : null,
          helper: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (statusIcon != null) ...[
                statusIcon.copyWith(color: statusColor),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  statusText ?? '',
                  style: Typographies.caption1Secondary
                      .copyWith(color: statusColor),
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          trailing: action,
          padding: const EdgeInsets.symmetric(vertical: 12),
          isOpaque: isOpaque,
        );

  CardNoBalanceCell.Chevron({
    Key? key,
    required Widget cardIcon,
    required String cardName,
    String? cardNumber,
    String? statusText,
    SvgPicture? statusIcon,
    VoidCallback? onTapChevron,
    Color? statusColor,
    bool isOpaque = true,
  }) : this(
          cardIcon: cardIcon,
          cardName: cardName,
          cardNumber: cardNumber,
          statusIcon: statusIcon,
          statusText: statusText,
          isOpaque: isOpaque,
          action: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTapChevron,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: ActionIcons.chevronRight16),
          ),
        );

  final Widget cardIcon;
  final String cardName;
  final String? cardNameTrailing;
  final String? cardNumber;
  final Widget? action;
  final String? statusText;
  final SvgPicture? statusIcon;

  @override
  Widget getHelper() {
    if (statusIcon != null || statusText != null) {
      return super.getHelper();
    }
    return const SizedBox.shrink();
  }

  @override
  Widget getBodySpace() {
    return const SizedBox(height: 2);
  }
}
