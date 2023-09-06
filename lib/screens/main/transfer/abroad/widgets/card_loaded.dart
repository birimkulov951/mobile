import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/domain/abroad/abroad_transfer_receiver_entity.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/widgets/receiver_item.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';

class CardLoaded extends StatelessWidget {
  const CardLoaded(
      {Key? key, required this.state, required this.onSelectReceiver})
      : super(key: key);

  final AbroadTransferReceiverEntity state;
  final OnItemSelect onSelectReceiver;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LocaleBuilder(builder: (context, locale) {
            return ReceiverItem(
              receiver: state,
              bankNameReplacement: locale.getText('bank_card_kazakhstan'),
              cardIcon: ReceiverBankIcon(bankIconUrl: state.bankIconUrl),
              onTap: onSelectReceiver,
            );
          }),
          const SizedBox(height: 8),
          const Divider(),
        ],
      ),
    );
  }
}

class ReceiverBankIcon extends StatelessWidget {
  const ReceiverBankIcon({
    Key? key,
    required this.bankIconUrl,
    this.iconWidth = 32.0,
    this.iconHeight = 24.0,
  }) : super(key: key);

  final String? bankIconUrl;
  final double iconWidth;
  final double iconHeight;

  @override
  Widget build(BuildContext context) {
    return bankIconUrl != null
        ? SvgPicture.network(
            bankIconUrl!,
            width: iconWidth,
            height: iconHeight,
          )
        : SvgPicture.asset(
            Assets.flagKazakhstan,
            fit: BoxFit.cover,
            width: iconWidth,
            height: iconHeight,
          );
  }
}
