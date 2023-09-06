import 'package:flutter/material.dart';

import 'package:mobile_ultra/domain/cards_by_phone_number/cards_by_phone_number_entity.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/main/transfer/transfer_by_phone/transfer_banks/widgets/card_item.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet.dart';

const _maxItemsLength = 7;

class BankCardsBottomSheet extends StatefulWidget {
  final List<BankCardEntity> cardList;
  final void Function(BankCardEntity) onCardSelected;

  const BankCardsBottomSheet({
    Key? key,
    required this.cardList,
    required this.onCardSelected,
  }) : super(key: key);

  static Future show({
    required BuildContext context,
    required List<BankCardEntity> cardList,
    required void Function(BankCardEntity) onCardSelected,
  }) =>
      viewModalSheet(
        context: context,
        compact: true,
        child: BankCardsBottomSheet(
          cardList: cardList,
          onCardSelected: onCardSelected,
        ),
      );

  @override
  State<BankCardsBottomSheet> createState() => _BankCardsBottomSheetState();
}

class _BankCardsBottomSheetState extends State<BankCardsBottomSheet> {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              locale.getText('select_card'),
              style: TextStyles.title5,
            ),
          ),
          SizedBox(height: 12),
          Expanded(
            flex: widget.cardList.length > _maxItemsLength ? 1 : 0,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.cardList.length,
              itemBuilder: (context, index) {
                final item = widget.cardList[index];

                return CardItem(
                  title: item.fullName,
                  cardType: item.cardType,
                  subtitle: item.maskedPan,
                  onTap: () => widget.onCardSelected(item),
                );
              },
            ),
          ),
        ],
      );
}
