import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/abroad/abroad_transfer_receiver_entity.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/widgets/item_padding.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/widgets/receiver_card_number.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/widgets/receiver_card_placeholder.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/widgets/receiver_item.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/widgets/receiver_list.dart';
import 'package:mobile_ultra/ui_models/shimmer.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

class CardBeforeLoading extends StatelessWidget {
  const CardBeforeLoading({
    Key? key,
    required this.cardInputValueState,
    required this.onTapCardNumber,
    required this.lastReceiversState,
    required this.scrollController,
    required this.onSelectReceiver,
  }) : super(key: key);

  final ListenableState<String> cardInputValueState;
  final VoidCallback onTapCardNumber;
  final EntityStateNotifier<List<AbroadTransferReceiverEntity>>
      lastReceiversState;
  final ScrollController scrollController;
  final OnItemSelect onSelectReceiver;

  Widget _cardNumber({
    required ListenableState<String> cardInputValueState,
    required VoidCallback onTapCardNumber,
  }) {
    return StateNotifierBuilder<String>(
      listenableState: cardInputValueState,
      builder: (_, state) {
        if (state == null || state.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTapCardNumber,
              child: ReceiverCardNumber(
                number: state,
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _lastReceivers({
    required EntityStateNotifier<List<AbroadTransferReceiverEntity>>
        lastReceiversState,
    required ScrollController scrollController,
    required OnItemSelect onSelectReceiver,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ItemPadding(
            child: TextLocale(
              'last_transfers',
              style: TextStyles.textBold,
            ),
          ),
          EntityStateNotifierBuilder<List<AbroadTransferReceiverEntity>>(
            listenableEntityState: lastReceiversState,
            builder: (_, state) {
              if (state == null) {
                return const SizedBox.shrink();
              }
              if (state.isEmpty) {
                return TextLocale(
                  'you_dont_have_transfers',
                  style: TextStyles.caption1MainSecondary,
                );
              }
              return ReceiverList(
                scrollController: scrollController,
                receivers: state,
                onItemSelected: onSelectReceiver,
              );
            },
            loadingBuilder: (_, __) {
              return ItemPadding(
                child: Shimmer(
                  child: Column(
                    children: [
                      ReceiverCardPlaceholder(),
                      ReceiverCardPlaceholder(),
                      ReceiverCardPlaceholder()
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _cardNumber(
              cardInputValueState: cardInputValueState,
              onTapCardNumber: onTapCardNumber),
          _lastReceivers(
            lastReceiversState: lastReceiversState,
            scrollController: scrollController,
            onSelectReceiver: onSelectReceiver,
          ),
        ],
      ),
    );
  }
}
