import 'package:flutter/material.dart';

import 'package:mobile_ultra/domain/abroad/abroad_transfer_receiver_entity.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/widgets/receiver_item.dart';

class TransferDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  final Size preferredSize = Size(double.infinity, 56);

  final AbroadTransferReceiverEntity receiver;

  TransferDetailsAppBar({
    Key? key,
    required this.receiver,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox.fromSize(
        size: preferredSize,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: BackButton(),
            ),
            ReceiverWidget(
              receiver: receiver,
              bankNameReplacement: locale.getText('bank_card_kazakhstan'),
              showArrow: false,
            )
          ],
        ),
      ),
    );
  }
}
