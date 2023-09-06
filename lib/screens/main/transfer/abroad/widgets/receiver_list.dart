import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/abroad/abroad_transfer_receiver_entity.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/widgets/receiver_item.dart';

class ReceiverList extends StatelessWidget {
  const ReceiverList({
    Key? key,
    required this.receivers,
    required this.onItemSelected,
    this.scrollController,
  }) : super(key: key);

  final OnItemSelect onItemSelected;
  final List<AbroadTransferReceiverEntity> receivers;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        itemCount: receivers.length,
        itemBuilder: (_, index) {
          final receiver = receivers[index];
          return LocaleBuilder(
            builder: (_, locale) => ReceiverItem(
              onTap: onItemSelected,
              bankNameReplacement: locale.getText('bank_card_kazakhstan'),
              receiver: receiver,
            ),
          );
        },
      ),
    );
  }
}
