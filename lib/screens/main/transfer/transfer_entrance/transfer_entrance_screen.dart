import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/remote_config/remote_config_entity.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/screens/main/transfer/transfer_entrance/transfer_entrance_screen_wm.dart';
import 'package:mobile_ultra/screens/main/transfer/transfer_entrance/widgets/common_list_item.dart';
import 'package:mobile_ultra/screens/main/transfer/transfer_entrance/widgets/receiver_placeholder.dart';
import 'package:mobile_ultra/screens/main/transfer/v3/widgets/entrance_screen_carousel_list.dart';
import 'package:mobile_ultra/screens/main/transfer/v3/widgets/previous_transfer_list.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:mobile_ultra/widgets/change_notifier_builder.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';
import 'package:ui_kit/ui_kit.dart' as uikit;

const _appBarTitleScale = 1.6;
const _bottomNavigationViewPadding = 24;

class TransferEntranceScreen
    extends ElementaryWidget<ITransferEntranceScreenWidgetModel> {
  const TransferEntranceScreen({
    required this.onQReadResult,
    Key? key,
  }) : super(wmFactory, key: key);
  final ValueChanged<String> onQReadResult;

  @override
  Widget build(ITransferEntranceScreenWidgetModel wm) {
    return Stack(
      children: [
        LocaleBuilder(
          builder: (context, locale) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverAppBar(
                  collapsedHeight: kToolbarHeight,
                  expandedHeight: kToolbarHeight + 24,
                  pinned: true,
                  backgroundColor: ColorNode.Background,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(left: 16, bottom: 12),
                    expandedTitleScale: _appBarTitleScale,
                    centerTitle: false,
                    title: ValueListenableBuilder<TransferScreenContent?>(
                      valueListenable: wm.screenContentState,
                      builder: (context, state, _) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TextLocale(
                                'transfers',
                                style: uikit.Typographies.title5,
                              ),
                              Visibility(
                                visible: (state
                                        is FocusedTransferScreenContent ||
                                    state is TransferScreenFocusedContentEmpty),
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: wm.onClearTap,
                                  child: Container(
                                    width: 24 / _appBarTitleScale,
                                    height: 24 / _appBarTitleScale,
                                    alignment: Alignment.center,
                                    child: uikit.ActionIcons.close,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: StateNotifierBuilder<String>(
                      listenableState: wm.helperState,
                      builder: (context, state) {
                        return uikit.RoundedContainer(
                          key: const Key(
                              WidgetIds.transferEntranceCardOrPhoneInput),
                          child: uikit.CardOrPhoneInput(
                            key: wm.inputKey,
                            hintText: locale.getText('cardOrPhone'),
                            helperText: state,
                            controller: wm.controller,
                            focusNode: wm.focusNode,
                            onScanCardTap: wm.onScanCardTap,
                            onGetContactTap: wm.onGetContactTap,
                            onClearTap: wm.onClearTap,
                            validator: wm.validator,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: ValueListenableBuilder<TransferScreenContent?>(
                    valueListenable: wm.screenContentState,
                    builder: (context, state, _) {
                      if (state is LoadingTransferScreenContent) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: ReceiverPlaceholder(),
                        );
                      }
                      if (state is FocusedTransferScreenContent) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewPadding.bottom +
                                kToolbarHeight +
                                _bottomNavigationViewPadding,
                          ),
                          child: PreviousTransferList(
                            onPressSavedTransfer: wm.onPreviousTransferTap,
                            listOfPreviousTransfers:
                                wm.previousTransfersFilteredList,
                          ),
                        );
                      }
                      if (state is TransferScreenFocusedContentEmpty) {
                        return const SizedBox.shrink();
                      }
                      if (state is PhoneFoundTransferScreenContent) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: GestureDetector(
                            onTap: wm.next,
                            child: uikit.RoundedContainer(
                              color: uikit.BackgroundColors.primary,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: uikit.CardNoBalanceCell.Chevron(
                                  //TODO: сделать переиспользуемым
                                  key: const Key(
                                      WidgetIds.transferEntranceFoundPhone),
                                  cardIcon: Container(
                                    decoration: const BoxDecoration(
                                      color: uikit.IconAndOtherColors.fill,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                    width: 56,
                                    height: 40,
                                    child: Center(
                                      child:
                                          uikit.ActionIcons.phoneAlt.copyWith(
                                        color:
                                            uikit.IconAndOtherColors.constant,
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                  ),
                                  cardName: locale.getText('phone_number'),
                                  cardNumber: uikit
                                      .formatPhoneNumber(state.phoneNumber),
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      if (state is CardFoundTransferScreenContent) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: GestureDetector(
                            onTap: wm.next,
                            child: uikit.RoundedContainer(
                              child: uikit.CardNoBalanceCell.Chevron(
                                key: const Key(
                                    WidgetIds.transferEntranceFoundCard),
                                cardIcon: uikit.cardIconFronType(
                                  state.p2pInfo.receiverCardType,
                                ),
                                cardName: state.p2pInfo.fio,
                                cardNumber:
                                    uikit.formatCardNumber(state.p2pInfo.pan),
                              ),
                            ),
                          ),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          EntranceScreenCarouselList(
                            onPressSelfTransfer: wm.onSelfTransferTap,
                            listOfPreviousTransfers: wm.previousTransfers,
                            onPressSavedTransfer: wm.onPreviousTransferTap,
                          ),
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: uikit.RoundedContainer(
                              title: uikit.HeadlineV2(
                                title: locale.getText('more_transfer_options'),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonListItem(
                                      key: const Key(
                                          WidgetIds.transferEntranceQRTransfer),
                                      icon: Assets.icQrPay,
                                      bodyText: locale.getText('qr_payment'),
                                      onTap: wm.onQrPay,
                                    ),
                                    EntityStateNotifierBuilder<
                                        RemoteConfigEntity>(
                                      listenableEntityState: wm.remoteConfig,
                                      builder: (context,
                                          RemoteConfigEntity? config) {
                                        if (config
                                                ?.isVisibleInternationalTransfer !=
                                            true) {
                                          return const SizedBox.shrink();
                                        }
                                        return Column(
                                          children: [
                                            const SizedBox(height: 24),
                                            CommonListItem(
                                              key: const Key(WidgetIds
                                                  .transferEntranceOverSeasTransfers),
                                              icon: Assets.transGran,
                                              bodyText: locale
                                                  .getText('overseas_payment'),
                                              onTap: wm
                                                  .showChooseCountryBottomSheet,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
        ChangeNotifierBuilder(
          changeNotifier: wm.focusNode,
          builder: (context) {
            return Positioned(
              bottom: wm.nextButtonBottom,
              left: 16,
              right: 16,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
                child: ValueListenableBuilder<TransferScreenContent?>(
                  valueListenable: wm.screenContentState,
                  builder: (context, state, _) {
                    final enabled = (state is FoundTransferScreenContent);
                    return enabled
                        ? RoundedButton(
                            key: const Key(
                                WidgetIds.transferEntranceContinueButton),
                            title: locale.getText('continue'),
                            onPressed: enabled ? wm.next : null,
                          )
                        : const SizedBox.shrink();
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
