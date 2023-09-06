import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/screens/card/v3/edit_card/edit_card_screen_wm.dart';
import 'package:mobile_ultra/screens/card/v3/edit_card/route/arguments.dart';
import 'package:mobile_ultra/screens/card/v3/edit_card/widgets/amount_info.dart';
import 'package:mobile_ultra/ui_models/app_bar/v2/app_bar_v2.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:ui_kit/ui_kit.dart' as uiKit;
import 'package:sprintf/sprintf.dart';

//todo Abdurahmon backend must give this
const _trackingPrice = '1 000';

class EditCardScreen extends ElementaryWidget<IEditCardScreenWidgetModel> {
  const EditCardScreen({
    required this.arguments,
    Key? key,
  }) : super(editCardScreenWidgetModelFactory, key: key);
  final EditCardScreenArguments arguments;

  @override
  Widget build(IEditCardScreenWidgetModel wm) {
    return MultiListenerRebuilder(
      listenableList: [
        wm.isLoading,
        wm.card,
      ],
      builder: (context) {
        final card = wm.card.value;
        return Scaffold(
          appBar: AppBarV2(
            title: Text(
              '${arguments.attachedCard.name}',
              style: uiKit.Typographies.title5,
            ),
            onBackTap: wm.onBackTap,
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    ValueListenableBuilder<int>(
                      valueListenable: wm.cardColor,
                      builder: (_, int color, ___) {
                        return uiKit.BigCard.big(
                          name: card.name!,
                          balance: sprintf(
                            locale.getText('sum_with_amount'),
                            [formatAmount(card.balance)],
                          ),
                          color: uiKit.ColorUtils.colorSelect[color]!,
                          logo: uiKit.bigCardLogo(card.type),
                          maskedPan: card.number ?? '',
                          expDate: formatExpDate(card.expDate),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    uiKit.RoundedContainer(
                      child: Column(
                        children: [
                          uiKit.OrdinaryInput(
                            controller: wm.cardNameController,
                            focusNode: wm.focusNode,
                            label: locale.getText('card_name'),
                            maxLength: 20,
                            inputUnfocusedStyle: uiKit.Typographies.textInput,
                            textInputAction: TextInputAction.done,
                          ),
                          ValueListenableBuilder<int>(
                            valueListenable: wm.cardColor,
                            builder: (_, int color, ___) {
                              return uiKit.ColorSelect(
                                changeColor: wm.changeColor,
                                chosenColor:
                                    uiKit.ColorUtils.colorSelect[color]!,
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                    if (card.type != Const.HUMO) ...[
                      const SizedBox(height: 12),
                      uiKit.RoundedContainer(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            children: [
                              uiKit.HeadlineV2(
                                title: locale.getText('track_payments'),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                locale.getText('track_payments_hint'),
                                style: uiKit.Typographies.caption1,
                              ),
                              const SizedBox(height: 12),
                              AmountInfo(
                                title: locale.getText('service_coast'),
                                trailing: sprintf(
                                  locale.getText('track_payments_price'),
                                  [_trackingPrice],
                                ),
                              ),
                              if (card.subscribed ?? false) ...[
                                AmountInfo(
                                  title: locale
                                      .getText('track_payments_activated_at'),
                                  trailing: card.subscribeLastDate == null
                                      ? ''
                                      : DateFormat('dd.MM.yyyy').format(
                                          DateFormat("yyyy-MM-dd'T'HH:mm:ss")
                                              .parse(card.subscribeLastDate!),
                                        ),
                                ),
                                const SizedBox(height: 16),
                                RoundedButton(
                                  title: 'track_off',
                                  onPressed: () => wm.trackPayments(card),
                                  bg: uiKit.ControlColors.secondaryActiveV2,
                                  color: uiKit.TextColors.primary,
                                ),
                              ] else ...[
                                const SizedBox(height: 16),
                                RoundedButton(
                                  title: 'track_on',
                                  onPressed: () => wm.trackPayments(card),
                                ),
                              ],
                              const SizedBox(height: 12),
                              InkWell(
                                onTap: wm.onPublicOfferTap,
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: locale
                                        .getText('track_payments_offer_1'),
                                    style: uiKit.Typographies.caption1Secondary,
                                    children: [
                                      TextSpan(
                                        text: locale.getText(
                                          'track_payments_offer_2',
                                        ),
                                        style: uiKit.Typographies.caption1Link,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    ValueListenableBuilder(
                      valueListenable: wm.isButtonEnabled,
                      builder: (_, bool isEnabled, __) {
                        return RoundedButton(
                          title: 'save',
                          onPressed: isEnabled
                              ? () {
                                  wm.editCard(card);
                                }
                              : null,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    RoundedButton(
                      title: 'remove_card',
                      color: uiKit.TextColors.secondary,
                      onPressed: () => wm.deleteCard(card.token!),
                      bg: Colors.transparent,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).viewPadding.bottom + 16,
                    ),
                  ],
                ),
              ),
              LoadingWidget(
                showLoading: wm.isLoading.value,
                withProgress: true,
              ),
            ],
          ),
        );
      },
    );
  }
}
