import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/abroad/abroad_transfer_receiver_entity.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/widgets/card_before_loading.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/widgets/card_loaded.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/widgets/card_loading.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/widgets/card_number_input.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/widgets/card_screen_body.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_receiver_search_screen/route/arguments.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_receiver_search_screen/transfer_abroad_receiver_search_screen_wm.dart';

class TransferAbroadReceiverSearchScreen
    extends ElementaryWidget<ITransferAbroadReceiverSearchScreenWidgetModel> {
  TransferAbroadReceiverSearchScreen({required this.arguments})
      : super(receiverSearchScreenWidgetModelFactory);

  final TransferAbroadReceiverSearchScreenRouteArguments arguments;

  @override
  Widget build(ITransferAbroadReceiverSearchScreenWidgetModel wm) {
    return GestureDetector(
      onTap: wm.unfocusCardInput,
      onPanStart: (_) => wm.unfocusCardInput(),
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: TextLocale('receiver'),
              centerTitle: false,
            ),
            body: CardScreenBody(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CardNumberInput(
                    key: const Key(WidgetIds.transferAbroadInput),
                    cardInputController: wm.cardInputController,
                    cardInputFormatters: wm.cardInputFormatters,
                    cardInputSuffixIconNameState:
                        wm.cardInputSuffixIconNameState,
                    onCardInputActionTap: wm.onCardInputActionTap,
                  ),
                  const SizedBox(height: 16),
                  EntityStateNotifierBuilder<AbroadTransferReceiverEntity?>(
                    listenableEntityState: wm.receiverState,
                    builder: (_, state) {
                      if (state == null) {
                        return CardBeforeLoading(
                          cardInputValueState: wm.cardInputValueState,
                          onTapCardNumber: wm.onTapCardNumber,
                          lastReceiversState: wm.lastReceiversState,
                          scrollController: wm.scrollController,
                          onSelectReceiver: wm.onSelectReceiver,
                        );
                      }
                      return CardLoaded(
                        key: const Key(
                            WidgetIds.transferAbroadFoundCard),
                        state: state,
                        onSelectReceiver: wm.onSelectReceiver,
                      );
                    },
                    loadingBuilder: (_, state) {
                      return CardLoading();
                    },
                  ),
                ],
              ),
            ),
          ),
          StateNotifierBuilder<bool>(
            listenableState: wm.isLoadingState,
            builder: (context, state) {
              return LoadingWidget(
                showLoading: state,
                withProgress: true,
              );
            },
          )
        ],
      ),
    );
  }
}
