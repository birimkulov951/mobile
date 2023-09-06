import 'package:flutter/material.dart';
import 'package:mobile_ultra/main.dart' show homeData;
import 'package:mobile_ultra/net/card/model/bonus_per_month.dart';
import 'package:mobile_ultra/net/history/history_up_container_presenter.dart';
import 'package:mobile_ultra/screens/base/base_cards_state.dart';
import 'package:mobile_ultra/screens/main/history/widgets/price_item.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';

class HistoryUpContainer extends StatefulWidget {
  const HistoryUpContainer({Key? key}) : super(key: key);

  @override
  State<HistoryUpContainer> createState() => _HistoryUpContainerState();
}

class _HistoryUpContainerState extends BaseCardsState<HistoryUpContainer>
    with HistoryUpnView {
  num debidSumMonth = 0;
  ValueNotifier<double> balanceUpdateNotifier = ValueNotifier(0);
  ValueNotifier<BonusPerMonth> bonusUpdateNotifier =
      ValueNotifier(BonusPerMonth());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    HistoryUpPresenter.debidSum(this).getDebidSum();
  }

  @override
  void initState() {
    super.initState();
    getBonusPerMonth();
  }

  @override
  Widget build(context) => Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          color: ColorNode.Background,
        ),
        padding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 24, top: 16),
        child: LocaleBuilder(
          builder: (_, locale) => Row(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: balanceUpdateNotifier,
                  builder: (context, balance, child) => Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ColorNode.ContainerColor,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: PriceItem(
                      title: locale.getText("cost") +
                          ' ${DateFormat(DateFormat.MONTH, locale.prefix).format(DateTime.now())}',
                      price:
                          "${formatAmount((debidSumMonth).toDouble())} ${locale.getText('sum')}",
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ColorNode.ContainerColor,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: ValueListenableBuilder(
                    valueListenable: bonusUpdateNotifier,
                    builder: (context, BonusPerMonth bonus, child) => PriceItem(
                      title: locale.getText('cashbacks') +
                          '${DateFormat(DateFormat.MONTH, locale.prefix).format(DateTime.now())}',
                      price: '${formatAmount((bonus.amount).toDouble())} '
                          '${locale.getText('sum')}',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  @override
  void onUpdateCommonBalance() {
    double balance = 0;
    homeData?.cards.forEach((card) {
      balance += card.balance ?? 0;
    });
    balanceUpdateNotifier.value = balance;
  }

  @override
  void onGetBonusPerMonth(BonusPerMonth bonus) {
    bonusUpdateNotifier.value = bonus;
  }

  @override
  void onMonthDebitSum({num? debidSum, String? error, errorBody}) {
    setState(() {
      if (debidSum != null) {
        debidSumMonth = debidSum;
      }
    });
  }
}
