import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_details_screen/route/arguments.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_details_screen/transfer_details_screen_wm.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_details_screen/widgets/transfer_details_app_bar.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_details_screen/widgets/transfer_details_cards_section.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/card/v2/card_item.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:mobile_ultra/widgets/card_select.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';
import 'package:mobile_ultra/widgets/overscroll_glow_absorber.dart';
import 'package:mobile_ultra/widgets/reset_focus.dart';

/// Экран деталей перевода за границу
class TransferDetailsScreen
    extends ElementaryWidget<ITransferDetailsScreenWidgetModel> {
  final TransferDetailsScreenRouteArguments arguments;

  const TransferDetailsScreen({
    required this.arguments,
    Key? key,
    WidgetModelFactory wmFactory =
        defaultTransferDetailsScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(ITransferDetailsScreenWidgetModel wm) {
    return ResetFocusWidget(
      child: SizedBox(
        height: wm.screenHeight,
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: ColorNode.Background,
              appBar: TransferDetailsAppBar(
                receiver: arguments.receiverEntity,
              ),
              body: OverscrollGlowAbsorber(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TransferDetailsCardsSection(
                        fromFieldKey: wm.fromFieldKey,
                        fromFieldManager: wm.fromFieldManager,
                        toFieldManager: wm.toFieldManager,
                        minSum: wm.minSumText,
                        rate: wm.rateText,
                        flagToCountryUrl:
                            arguments.transferCountryEntity.flagToCountryUrl,
                        fromAmountValidate: wm.fromAmountValidate,
                        errorFromState: wm.errorFromState,
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: TextLocale(
                          'where',
                          style: TextStyles.captionButton,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: ColorNode.ContainerColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: StateNotifierBuilder<AttachedCard?>(
                          listenableState: wm.selectFromCardState,
                          builder: (_, AttachedCard? card) {
                            return card == null
                                ? CardSelect.card(
                                    key: const Key(WidgetIds
                                        .transferAbroadDetailsSelectCard),
                                    onTap: () => wm.selectFromCard(),
                                  )
                                : CardItem(
                                    key: const Key(WidgetIds
                                        .transferAbroadDetailsChangeCard),
                                    uCard: card,
                                    onTap: (_) => wm.selectFromCard(),
                                  );
                          },
                        ),
                      ),
                      AnimatedPadding(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.only(
                          top: 0,
                          bottom: 76,
                          left: 16,
                          right: 16,
                        ),
                        child: const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: wm.bottomPadding,
              left: 16,
              right: 16,
              child: StateNotifierBuilder<bool>(
                  listenableState: wm.buttonState,
                  builder: (context, bool? isActive) {
                    return RoundedButton(
                      key: const Key(WidgetIds
                          .transferAbroadDetailsContinueButton),
                      title: 'continue',
                      disabledBgColor: ColorNode.GreenDisabled,
                      onPressed: (isActive ?? false) ? wm.onPressNext : null,
                    );
                  }),
            ),
            StateNotifierBuilder<bool>(
              listenableState: wm.loadState,
              builder: (context, bool? isLoading) {
                return LoadingWidget(
                  showLoading: isLoading ?? false,
                  withProgress: true,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
