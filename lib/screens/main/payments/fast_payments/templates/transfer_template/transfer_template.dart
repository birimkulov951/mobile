import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/transfer_template/route/transfer_template_arguments.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/transfer_template/transfer_template_wm.dart';
import 'package:mobile_ultra/screens/main/transfer/v2/card_item_transfer.dart';
import 'package:mobile_ultra/ui_models/app_bar/custom_app_bar.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/card/v2/card_item.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/input_formatter/amount_formatter.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:mobile_ultra/widgets/card_select.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

class TransferTemplate extends ElementaryWidget<ITransferTemplateWidgetModel> {
  const TransferTemplate({
    required this.arguments,
    Key? key,
  }) : super(transferTemplateWidgetModelFactory, key: key);

  final TransferTemplateRouteArguments arguments;

  @override
  Widget build(ITransferTemplateWidgetModel wm) => GestureDetector(
        onTap: wm.onScaffoldTap,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: StateNotifierBuilder<String>(
              listenableState: wm.titleState,
              builder: (context, title) => PaynetAppBar(
                title ?? '',
                actions: [
                  const SizedBox(width: 12),
                  IconButton(
                    key: const Key(WidgetIds.transferTemplateSettings),
                    icon: SvgPicture.asset(Assets.noShapeSettings),
                    onPressed: wm.onSettingsTap,
                  ),
                ],
              ),
            ),
          ),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            reverse: true,
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ItemContainer(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: ColorNode.ContainerColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                            ),
                            child: TextLocale(
                              'where',
                              style: TextStyles.captionButton,
                            ),
                          ),
                          EntityStateNotifierBuilder<AttachedCard?>(
                            listenableEntityState: wm.currentCard,
                            builder: (_, state) {
                              if (state != null) {
                                return CardItem(
                                  key: const Key(
                                      WidgetIds.transferTemplateChangeCard),
                                  uCard: state,
                                  margin: EdgeInsets.zero,
                                  onTap: wm.onCardChange,
                                );
                              }
                              return CardSelect.card(
                                key: const Key(
                                    WidgetIds.transferTemplateSelectCard),
                                onTap: wm.onCardSelect,
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          const Divider(
                            height: .8,
                            indent: 16,
                            endIndent: 16,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 16,
                              left: 16,
                            ),
                            child: TextLocale(
                              'wheres',
                              style: TextStyles.captionButton,
                            ),
                          ),
                          CardItemTransfer.fromSvg(
                            color: ColorNode.ContainerColor,
                            image: Assets.iconCard,
                            text: formatCardNumberSecondary(
                              arguments.template.transferData!.pan2!,
                            ),
                            title: arguments.template.transferData!.fio!,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ItemContainer(
                      margin: const EdgeInsets.only(
                        top: 12,
                      ),
                      padding: EdgeInsets.only(
                        bottom: wm.bottomPadding,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      backgroundColor: ColorNode.ContainerColor,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            child: StateNotifierBuilder<String>(
                              listenableState: wm.commissionTextState,
                              builder: (context, commission) => TextField(
                                key: const Key(
                                    WidgetIds.transferTemplateAmountInput),
                                focusNode: wm.amountFocus,
                                controller: wm.amountController,
                                style: TextStyles.textInputBold,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  errorText: wm.error,
                                  labelText: locale.getText('amount'),
                                  helperText: commission,
                                  errorStyle: TextStyles.caption1.copyWith(
                                    color: ColorNode.Red,
                                  ),
                                  floatingLabelStyle:
                                      TextStyles.caption1.copyWith(
                                    color: wm.error == null
                                        ? ColorNode.MainSecondary
                                        : ColorNode.Red,
                                  ),
                                  helperStyle: TextStyles.caption1MainSecondary,
                                  suffixIcon: StateNotifierBuilder<bool>(
                                    listenableState:
                                        wm.isAmountClearIconShownState,
                                    builder: (context, state) => IconButton(
                                      icon: state != null && state
                                          ? SvgPicture.asset(Assets.clear)
                                          : const SizedBox.shrink(),
                                      onPressed: wm.onAmountClear,
                                    ),
                                  ),
                                ),
                                onChanged: wm.onAmountChanged,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]'),
                                  ),
                                  AmountFormatter(isCurrencyShown: true),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              top: 4,
                              right: 16,
                            ),
                            child: StateNotifierBuilder<ButtonStatus>(
                              listenableState: wm.isVisibleButtonState,
                              builder: (context, ButtonStatus? state) =>
                                  RoundedButton(
                                key: const Key(
                                    WidgetIds.transferTemplateContinueButton),
                                title: 'continue',
                                disabledBgColor: ColorNode.GreenDisabled,
                                loading: state == ButtonStatus.loading,
                                margin: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                onPressed: state == ButtonStatus.clickable
                                    ? wm.onCheckAndGotoConfirmTransfer
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
