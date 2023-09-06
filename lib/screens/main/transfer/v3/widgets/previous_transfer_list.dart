import 'package:elementary/elementary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/transfer/previous_transfer_entity.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/screens/main/transfer/v3/widgets/previous_transfer_shimmer.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:ui_kit/ui_kit.dart' as uikit;

const _shimmerListLength = 4;

class PreviousTransferList extends StatelessWidget {
  final ValueChanged<PreviousTransferEntity> onPressSavedTransfer;
  final EntityStateNotifier<List<PreviousTransferEntity>>
      listOfPreviousTransfers;

  const PreviousTransferList({
    required this.onPressSavedTransfer,
    required this.listOfPreviousTransfers,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return EntityStateNotifierBuilder<List<PreviousTransferEntity>>(
      listenableEntityState: listOfPreviousTransfers,
      builder: (_, List<PreviousTransferEntity>? state) {
        return state!.isEmpty
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: uikit.RoundedContainer(
                  title: uikit.HeadlineV2(
                    title: locale.getText('lasts'),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.length <= 10 ? state.length : 10,
                    itemBuilder: (_, index) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onPressSavedTransfer(state[index]),
                        child: uikit.CardNoBalanceCell.Chevron(
                          cardIcon: uikit.cardIconFronType(
                            state[index].type,
                          ),
                          cardName: lowerCasedCardName(state[index].name),
                          cardNumber: formatCardNumber(state[index].maskedPan),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(width: 30),
                  ),
                ),
              );
      },
      loadingBuilder: (_, List<PreviousTransferEntity>? state) {
        return ListView.separated(
          itemCount: _shimmerListLength,
          itemBuilder: (context, index) {
            return const PreviousTransferShimmer();
          },
          separatorBuilder: (_, __) => const SizedBox(height: 12),
        );
      },
    );
  }
}
