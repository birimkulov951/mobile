import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/screens/main/transfer/v3/transfer_screen/route/arguments.dart';
import 'package:mobile_ultra/screens/main/transfer/v3/transfer_screen/transfer_screen_wm.dart';
import 'package:mobile_ultra/screens/main/transfer/v3/transfer_screen/widgets/amount_input_widget.dart';
import 'package:mobile_ultra/screens/main/transfer/v3/transfer_screen/widgets/from_to_cards_container.dart';
import 'package:mobile_ultra/ui_models/app_bar/custom_app_bar.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';

class TransferScreen extends ElementaryWidget<ITransferScreenWidgetModel> {
  final TransferScreenArguments arguments;

  const TransferScreen({
    Key? key,
    required this.arguments,
  }) : super(transferScreenWidgetModelFactory, key: key);

  @override
  Widget build(ITransferScreenWidgetModel wm) {
    return Scaffold(
      appBar: PaynetAppBar(wm.title),
      body: StateNotifierBuilder(
          listenableState: wm.isLoadingState,
          builder: (_, __) {
            return Stack(
              children: [
                SafeArea(
                  minimum: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  child: CustomScrollView(
                    reverse: true,
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          children: [
                            const SizedBox(height: 4),
                            FromToCardsContainer(
                              selectFromCardState: wm.selectFromCardState,
                              selectToCardState: wm.selectToCardState,
                              onTapFrom: wm.selectFromCard,
                              onTapTo: wm.selectToCard,
                              isSelfTransfer: wm.isSelfTransfer,
                              warningText: wm.warningText,
                              swapSenderWithReceiver: wm.swapSenderWithReceiver,
                              cardName: arguments.transferWay.cardName,
                              resultPan: formatCardNumber(arguments.transferWay.displayedPan),
                              cardType: arguments.transferWay.cardType,
                            ),
                            const Expanded(child: SizedBox(height: 12)),
                            Form(
                              key: wm.formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  StateNotifierBuilder(
                                    listenableState: wm.commission,
                                    builder: (_, __) => StateNotifierBuilder(
                                        listenableState: wm.commissionAmount,
                                        builder: (_, __) {
                                          return AmountInputWidget(
                                            validator: wm.validator,
                                            commissionAmount:
                                            wm.commissionAmount.value,
                                            commission: wm.commission.value!,
                                            amountBigController:
                                            wm.amountBigController,
                                          );
                                        }),
                                  ),
                                  const SizedBox(height: 12),
                                  StateNotifierBuilder<bool>(
                                      listenableState: wm.isButtonEnabledState,
                                      builder: (_, bool? state) {
                                        return RoundedButton(
                                          key: const Key(WidgetIds
                                              .transferScreenContinueButton),
                                          onPressed:
                                          state == false ? null : wm.pay,
                                          title: locale.getText('continue'),
                                          loading:
                                          wm.isLoadingState.value == true,
                                        );
                                      }),
                                  const SizedBox(height: 12),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                LoadingWidget(
                  showLoading: wm.isLoadingState.value == true,
                ),
              ],
            );
          }),
    );
  }
}
