import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_confirmation/route/arguments.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_confirmation/transfer_abroad_confirmation_screen_wm.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_confirmation/widgets/transfer_item_card.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/widgets/card_loaded.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/card/v2/mini_card_widget.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';
import 'package:sprintf/sprintf.dart';

class TransferAbroadConfirmationScreen
    extends ElementaryWidget<ITransferAbroadConfirmationScreenWidgetModel> {
  const TransferAbroadConfirmationScreen({
    Key? key,
    required this.arguments,
  }) : super(transferConfirmationScreenWidgetModelFactory, key: key);

  final TransferAbroadConfirmationScreenRouteArguments arguments;

  @override
  Widget build(ITransferAbroadConfirmationScreenWidgetModel wm) {
    return Builder(
      builder: (BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: TextLocale('payment_confirm'),
          titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        body: StateNotifierBuilder(
          listenableState: wm.isLoadingState,
          builder: (_, __) => Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextLocale(
                      "where",
                      style: TextStyles.captionButton,
                    ),
                    SizedBox(height: 12),
                    TransferItemCard(
                      title: wm.fromBankName,
                      subtitle: wm.fromBankAmount,
                      imageWidget: MiniCardWidget(uCard: wm.fromCard),
                    ),
                    SizedBox(height: 20),
                    TextLocale(
                      "wheres",
                      style: TextStyles.captionButton,
                    ),
                    SizedBox(height: 12),
                    TransferItemCard(
                      title: wm.toBankName,
                      subtitle: wm.toBankAmount,
                      imageWidget: ReceiverBankIcon(
                        bankIconUrl: wm.toCard.bankIconUrl,
                        iconWidth: 56,
                        iconHeight: 40,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ColorNode.ContainerColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      TextLocale(
                        'you_are_transferring',
                        style: TextStyles.captionButton,
                      ),
                      SizedBox(height: 8),
                      Text(
                        sprintf(
                          locale.getText("amount_format"),
                          [wm.amount],
                        ),
                        style: TextStyles.title3
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4),
                      TextLocale(
                        "no_commission",
                        style: TextStyles.caption1MainSecondary,
                      ),
                      SizedBox(height: 24),
                      TextLocale(
                        'receiver_gets',
                        style: TextStyles.captionButton,
                      ),
                      SizedBox(height: 8),
                      Text(
                        sprintf(
                          locale.getText("tenge_with_amount"),
                          [wm.payAmount],
                        ),
                        style: TextStyles.title3
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4),
                      Text(
                        sprintf(
                          locale
                              .getText('abroad_field_to_description_rate_tng'),
                          [wm.exchangeRate],
                        ),
                        style: TextStyles.caption1MainSecondary,
                      ),
                      SizedBox(height: 12),
                      if (wm.isExchangeRateChanged)
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: ColorNode.Main,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                Assets.operationsAssist,
                                width: 16,
                                height: 16,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: TextLocale(
                                  'while_waiting_rate_changed',
                                  style: TextStyles.caption1,
                                ),
                              )
                            ],
                          ),
                        ),
                      SizedBox(height: 24),
                      RoundedButton(
                        key: const Key(WidgetIds
                            .transferAbroadTransferConfirmButton),
                        margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewPadding.bottom,
                        ),
                        title: locale.getText('make_transfer'),
                        loading: wm.isLoadingState.value ?? false,
                        onPressed: () {
                          wm.makeTransfer(
                            billId: arguments.rateEntity.billId,
                            fromCard: wm.fromCard,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              LoadingWidget(showLoading: wm.isLoadingState.value),
            ],
          ),
        ),
      ),
    );
  }
}
