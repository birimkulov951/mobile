import 'package:flutter/material.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/widgets/receiver_card_placeholder.dart';

class CardLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ReceiverCardPlaceholder(),
        const SizedBox(height: 8),
        const Divider(),
      ],
    );
  }
}
