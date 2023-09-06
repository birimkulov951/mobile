import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/transfer/previous_transfer_entity.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/screens/main/transfer/v3/widgets/carousel_list_item.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:mobile_ultra/widgets/quick_actions_shimmer.dart';

const _carouselListHeight = 124.0;
const _shimmerListLength = 5;

class EntranceScreenCarouselList extends StatelessWidget {
  const EntranceScreenCarouselList({
    required this.onPressSelfTransfer,
    required this.onPressSavedTransfer,
    required this.listOfPreviousTransfers,
    super.key,
  });

  final VoidCallback onPressSelfTransfer;
  final Function(PreviousTransferEntity) onPressSavedTransfer;
  final EntityStateNotifier<List<PreviousTransferEntity>>
      listOfPreviousTransfers;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _carouselListHeight,
      child: EntityStateNotifierBuilder<List<PreviousTransferEntity>>(
        listenableEntityState: listOfPreviousTransfers,
        builder: (_, List<PreviousTransferEntity>? state) {
          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              final actualIndex = index - 1;
              final double leftPadding = index == 0 ? 16 : 0;
              return Container(
                padding: EdgeInsets.only(
                  left: leftPadding,
                ),
                alignment: Alignment.topCenter,
                child: CarouselListItem(
                  key: index == 0
                      ? const Key(
                          WidgetIds.transferEntranceTransfersListToYourSelf)
                      : Key(
                          '${WidgetIds.transferEntranceTransfersList}_$index',
                        ),
                  itemName: index == 0
                      ? locale.getText('your_self')
                      : lowerCasedCardName(state![actualIndex].name),
                  onItemTap: () {
                    if (index == 0) {
                      onPressSelfTransfer();
                    } else {
                      onPressSavedTransfer(state![actualIndex]);
                    }
                  },
                  cardType: index == 0 ? null : state?[index - 1].type,
                  isTransferToSelfItem: index == 0,
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 4),
            itemCount: state?.length == null ? 1 : state!.length + 1,
          );
        },
        loadingBuilder: (_, List<PreviousTransferEntity>? state) {
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              final isFirst = index == 0;
              final double leftPadding = isFirst ? 16 : 0;

              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                  left: leftPadding,
                ),
                child: !isFirst
                    ? const QuickActionsShimmer(itemCount: 4)
                    : CarouselListItem(
                        key: const Key(
                            WidgetIds.transferEntranceTransfersListToYourSelf),
                        itemName: locale.getText('your_self'),
                        onItemTap: () {
                          onPressSelfTransfer();
                        },
                        cardType: null,
                        isTransferToSelfItem: true,
                      ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 4),
            itemCount: _shimmerListLength,
          );
        },
      ),
    );
  }
}
