import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/domain/transfer/transfer_way_entity.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/screens/main/transfer/v3/transfer_confirmation_screen/route/arguments.dart';
import 'package:mobile_ultra/screens/main/transfer/v3/transfer_confirmation_screen/transfer_confirmation_screen_wm.dart';
import 'package:mobile_ultra/ui_models/app_bar/custom_app_bar.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:sprintf/sprintf.dart';

class TransferConfirmationScreen
    extends ElementaryWidget<ITransferConfirmationScreenWidgetModel> {
  const TransferConfirmationScreen({
    required this.arguments,
    Key? key,
  }) : super(wmFactory, key: key);

  final TransferConfirmationScreenArguments arguments;

  @override
  Widget build(ITransferConfirmationScreenWidgetModel wm) {
    return ValueListenableBuilder<bool>(
      valueListenable: wm.isLoadingState,
      builder: (context, isLoading, _) {
        return Scaffold(
          appBar: PaynetAppBar('transfer_confirm'),
          body: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 8),
                    RoundedContainer(
                      color: Colors.transparent,
                      title: Text(
                        locale.getText("where"),
                        style: Typographies.caption1Secondary,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CardCell(
                          cardIcon: MiniCard(
                            lastFour: wm.getLastFour(
                              arguments.senderCard.number!,
                            ),
                            cardBrand: SvgPicture.asset(
                              wm.getCardLogoAsset(arguments.senderCard.type!),
                            ),
                            backgroundColor: ColorUtils
                                .colorSelect[arguments.senderCard.color!]!,
                          ),
                          cardName: arguments.senderCard.name!,
                          cardNameTrailing: ' • ${wm.getLastFour(
                            arguments.senderCard.number!,
                          )}',
                          cardBalance:
                              formatAmount(arguments.senderCard.balance),
                          cardCurrency: locale.getText('sum'),
                        ),
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        final transferWay = arguments.transferWay;
                        if (transferWay is TransferWayByOwnCardEntity) {
                          return RoundedContainer(
                            color: Colors.transparent,
                            title: Text(
                              locale.getText("wheres"),
                              style: Typographies.caption1Secondary,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: CardCell(
                                cardIcon: MiniCard(
                                  lastFour: wm.getLastFour(
                                    transferWay.ownCard.number!,
                                  ),
                                  cardBrand: SvgPicture.asset(
                                    wm.getCardLogoAsset(
                                      transferWay.ownCard.type!,
                                    ),
                                  ),
                                  backgroundColor: ColorUtils
                                      .colorSelect[transferWay.ownCard.color!]!,
                                ),
                                cardName:
                                    '${transferWay.ownCard.name!} • ${wm.getLastFour(
                                  transferWay.ownCard.number!,
                                )}',
                                cardBalance:
                                    formatAmount(transferWay.ownCard.balance),
                                cardCurrency: locale.getText('sum'),
                              ),
                            ),
                          );
                        }

                        return RoundedContainer(
                          color: Colors.transparent,
                          title: Text(
                            locale.getText("wheres"),
                            style: Typographies.caption1Secondary,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: CardNoBalanceCell(
                              cardIcon: cardIconFronType(
                                arguments.transferWay.cardType,
                              ),
                              cardName: arguments.transferWay.cardName,
                              cardNumber: arguments.transferWay.displayedPan,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        locale.getText("you_transfer"),
                        style: Typographies.textMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${formatAmount(arguments.amount.toDouble())} ${locale.getText("sum")}',
                        style: Typographies.title2,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        sprintf(
                          locale.getText('commission_f'),
                          [
                            arguments.commissionPercent,
                            formatAmount(
                              (arguments.amount * arguments.commissionPercent) /
                                  100,
                            ),
                          ],
                        ),
                        style: Typographies.caption1Secondary,
                      ),
                      SizedBox(
                        height: 100,
                        child: Row(
                          children: const [
                            Expanded(
                              child: SizedBox(),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              LoadingWidget(showLoading: isLoading),
              Positioned(
                bottom: 32,
                left: 16,
                right: 16,
                child: RoundedButton(
                  key: const Key(
                      WidgetIds.transferConfirmationTransferButton),
                  loading: isLoading,
                  title: sprintf(
                    locale.getText('transfer_with_amount'),
                    [
                      formatAmount(arguments.amount.toDouble()),
                    ],
                  ),
                  onPressed: wm.pay,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
