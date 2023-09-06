import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/cards_by_phone_number/cards_by_phone_number_entity.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/screens/main/transfer/transfer_by_phone/transfer_banks/route/transfer_banks_screen_arguments.dart';
import 'package:mobile_ultra/screens/main/transfer/transfer_by_phone/transfer_banks/transfer_banks_screen_wm.dart';
import 'package:mobile_ultra/screens/main/transfer/transfer_by_phone/transfer_banks/widgets/bank_item.dart';
import 'package:mobile_ultra/screens/main/transfer/transfer_by_phone/transfer_banks/widgets/bank_item_placeholder.dart';
import 'package:mobile_ultra/ui_models/app_bar/custom_app_bar.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/ui_models/shimmer.dart';
import 'package:ui_kit/ui_kit.dart' as uikit;

const _shimmerItemLength = 12;

class TransferBanksScreen extends ElementaryWidget<IBanksScreenWidgetModel> {
  TransferBanksScreen({required this.arguments})
      : super(transferBanksScreenWidgetModelFactory);

  final TransferBanksScreenRouteArguments arguments;

  @override
  Widget build(IBanksScreenWidgetModel wm) => Scaffold(
        appBar: PynetAppBar(locale.getText('choose_bank')),
        body: ItemContainer(
          margin: EdgeInsets.only(top: 4, left: 16, right: 16),
          height: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: uikit.SearchInputV2(
                        focusNode: wm.searchFocus,
                        controller: wm.searchController,
                        hintText: locale.getText('bank_name'),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: EntityStateNotifierBuilder<List<BankEntity>?>(
                  listenableEntityState: wm.searchItemsState,
                  builder: (_, state) {
                    if (state == null) {
                      return const SizedBox.shrink();
                    }

                    return ListView.builder(
                      itemCount: state.length,
                      itemBuilder: (_, index) {
                        final bank = state[index];

                        return BankItem(
                          title: bank.bankName,
                          iconUrl: bank.logo,
                          onTap: () => wm.onBankTap(bank),
                        );
                      },
                    );
                  },
                  loadingBuilder: (_, __) {
                    return ListView.builder(
                      itemCount: _shimmerItemLength,
                      itemBuilder: (_, __) => Shimmer(
                        child: BankItemPlaceholder(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
}
