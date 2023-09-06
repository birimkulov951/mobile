import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/cards/field_switcher.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/card_addition/card_addition_screen_wm.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/card_addition/route/arguments.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/widgets/card_for_addition.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/widgets/field_switcher_container.dart';
import 'package:mobile_ultra/ui_models/app_bar/custom_app_bar.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:ui_kit/ui_kit.dart';

class CardAdditionScreen
    extends ElementaryWidget<ICardAdditionScreenWidgetModel> {
  const CardAdditionScreen({
    required this.arguments,
    Key? key,
  }) : super(cardAdditionScreenWidgetModelFactory, key: key);

  final CardAdditionScreenRouteArguments arguments;

  @override
  Widget build(ICardAdditionScreenWidgetModel wm) {
    return StateNotifierBuilder<bool>(
      listenableState: wm.isLoadingState,
      builder: (_, viewLoading) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: BackgroundColors.Default,
              appBar: PaynetAppBar(
                'card_addition',
              ),
              body: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StateNotifierBuilder<int>(
                          listenableState: wm.selectedCardColorState,
                          builder: (_, selectedColor) => Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              StateNotifierBuilder<CardType?>(
                                listenableState: wm.selectedCardTypeState,
                                builder: (_, cardType) => CardForAddition(
                                  cardType: cardType,
                                  colorsList:
                                      ColorUtils.colorSelect.values.toList(),
                                  selectedCardColor: selectedColor!,
                                  cardNumberFocusNode: wm.cardNumberFocus,
                                  cardNumberController: wm.cardNumberCtrl,
                                  cardExpirationDateFocusNode:
                                      wm.cardExpireFocus,
                                  cardExpirationDateController:
                                      wm.cardExpireCtrl,
                                  onScanCardTap: wm.onScanCardTap,
                                  cardNumberKey: wm.cardNumberKey,
                                  cardNumberValidator: wm.cardNumberValidator,
                                  cardExpKey: wm.cardExpKey,
                                  cardExpValidator: wm.cardExpValidator,
                                ),
                              ),
                              StateNotifierBuilder<String>(
                                listenableState: wm.errorTextState,
                                builder: (_, errorText) {
                                  if (errorText == null) {
                                    return const SizedBox(height: 12);
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 32,
                                    ),
                                    child: Text(
                                      errorText,
                                      textAlign: TextAlign.left,
                                      style: Typographies.caption1.copyWith(
                                        color: TextColors.error,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: ColorSelect(
                                  chosenColor:
                                      ColorUtils.colorSelect[selectedColor!]!,
                                  changeColor: wm.onCardColorChanged,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            StateNotifierBuilder<bool>(
                              listenableState: wm.isButtonClickableState,
                              builder: (_, isButtonClickable) => Padding(
                                padding: EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  bottom: wm.bottomPadding,
                                ),
                                child: RoundedButton(
                                  key: const Key(
                                      WidgetIds.cardAdditionContinueButton),
                                  title: 'continue',
                                  onPressed: isButtonClickable!
                                      ? wm.attemptToAddNewCard
                                      : null,
                                  loading: viewLoading!,
                                ),
                              ),
                            ),
                            StateNotifierBuilder<FieldSwitcher>(
                              listenableState: wm.fieldSwitcherState,
                              builder: (_, fieldSwitcherData) {
                                return FieldSwitcherContainer(
                                  fieldSwitcherData: fieldSwitcherData!,
                                  onReadyButtonTap: wm.onReadyButtonTap,
                                  onPrev: wm.onPrevTap,
                                  onNext: wm.onNextTap,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            LoadingWidget(
              showLoading: viewLoading,
            ),
          ],
        );
      },
    );
  }
}
