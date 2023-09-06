import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/abroad/abroad_transfer_receiver_entity.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/widgets/card_loaded.dart';

import 'package:mobile_ultra/screens/main/transfer/abroad/widgets/item_padding.dart';

typedef OnItemSelect = void Function(AbroadTransferReceiverEntity);

class ReceiverItem extends StatelessWidget {
  const ReceiverItem({
    Key? key,
    required this.receiver,
    required this.bankNameReplacement,
    this.cardIcon,
    this.onTap,
  }) : super(key: key);

  final AbroadTransferReceiverEntity receiver;
  final OnItemSelect? onTap;
  final Widget? cardIcon;
  final String bankNameReplacement;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap?.call(receiver),
      child: ItemPadding(
        child: ReceiverWidget(
          receiver: receiver,
          bankNameReplacement: bankNameReplacement,
          cardIcon: cardIcon,
        ),
      ),
    );
  }
}

class ReceiverWidget extends StatelessWidget {
  final Widget? cardIcon;
  final AbroadTransferReceiverEntity receiver;
  final String bankNameReplacement;
  final bool showArrow;

  const ReceiverWidget({
    Key? key,
    required this.receiver,
    required this.bankNameReplacement,
    this.cardIcon,
    this.showArrow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _CardIcon(
              cardIcon: cardIcon,
              receiver: receiver,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  receiver.bankName ?? bankNameReplacement,
                  style: TextStyles.textRegular,
                ),
                const SizedBox(height: 4),
                Text(
                  receiver.maskedPan,
                  style: TextStyles.caption1MainSecondary,
                ),
              ],
            ),
          ],
        ),
        if (showArrow) Icon(Icons.chevron_right),
      ],
    );
  }
}

class _CardIcon extends StatelessWidget {
  const _CardIcon({
    Key? key,
    this.cardIcon,
    required this.receiver,
  }) : super(key: key);

  final Widget? cardIcon;
  final AbroadTransferReceiverEntity receiver;

  @override
  Widget build(BuildContext context) {
    return cardIcon ?? ReceiverBankIcon(bankIconUrl: receiver.bankIconUrl);
  }
}
