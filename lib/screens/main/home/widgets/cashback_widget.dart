import 'package:elementary/elementary.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/home/monthly_cashback_entity.dart';
import 'package:mobile_ultra/domain/home/weekly_cashback_entity.dart';
import 'package:mobile_ultra/screens/main/home/widgets/shimmer/monthly_cashback_shimmer.dart';
import 'package:mobile_ultra/screens/main/home/widgets/shimmer/weekly_cashback_shimmer.dart';
import 'package:mobile_ultra/widgets/balance_widget.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';
import 'package:paynet_uikit/paynet_uikit.dart';

const _cashbackWidgetHeight = 120.0;

class CashbackWidget extends StatelessWidget {
  const CashbackWidget({
    required this.isBalanceHidden,
    required this.monthlyCashback,
    required this.weeklyCashback,
    super.key,
  });

  final bool isBalanceHidden;
  final EntityStateNotifier<MonthlyCashbackEntity> monthlyCashback;
  final EntityStateNotifier<WeeklyCashbackEntity> weeklyCashback;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _cashbackWidgetHeight,
      padding: const EdgeInsets.all(12.0),
      decoration: const BoxDecoration(
        color: BackgroundColors.primary,
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconContainer(
                      color: TextColors.accent,
                      size: 16.0,
                      child: OperationIcons.cashback.copyWith(
                        color: IconAndOtherColors.constant,
                        height: 14.0,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    const TextLocale(
                      'my_cashback',
                      style: Typographies.captionButton,
                    ),
                  ],
                ),
                const Spacer(),
                EntityStateNotifierBuilder(
                  listenableEntityState: monthlyCashback,
                  loadingBuilder: (_, __) => const MonthlyCashbackShimmer(),
                  builder: (_, MonthlyCashbackEntity? cashback) {
                    if (cashback == null) {
                      return const SizedBox.shrink();
                    }
                    return _MonthlyCashbackWidget(
                      currentMonth: cashback.currentMonth,
                      amount: cashback.amount,
                      isBalanceHidden: isBalanceHidden,
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: EntityStateNotifierBuilder(
              listenableEntityState: weeklyCashback,
              loadingBuilder: (_, __) => const WeeklyCashbackShimmer(),
              builder: (_, WeeklyCashbackEntity? weeklyCashback) {
                if (weeklyCashback == null) {
                  return const SizedBox.shrink();
                }
                return _CashbackStatistics(
                  isBalanceHidden: isBalanceHidden,
                  weeklyCashback: weeklyCashback,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthlyCashbackWidget extends StatelessWidget {
  const _MonthlyCashbackWidget({
    required this.amount,
    required this.currentMonth,
    required this.isBalanceHidden,
  });

  final double amount;
  final int currentMonth;
  final bool isBalanceHidden;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BalanceWidget.big(
          amount: amount,
          hideBalance: isBalanceHidden,
        ),
        TextLocale(
          'month_$currentMonth',
          style: Typographies.caption1Secondary,
        ),
      ],
    );
  }
}

class _CashbackStatistics extends StatelessWidget {
  const _CashbackStatistics({
    required this.isBalanceHidden,
    required this.weeklyCashback,
  });

  final bool isBalanceHidden;
  final WeeklyCashbackEntity weeklyCashback;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        color: BackgroundColors.secondary,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              TextLocale(
                'today',
                style: Typographies.cashbackTextRegularSecondary,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 2.0,
                ),
                decoration: const BoxDecoration(
                  color: TextColors.accent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                child: BalanceWidget.small(
                  amount: weeklyCashback.todayCashback.amount,
                  hideBalance: isBalanceHidden,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Expanded(
            child: BarChart(
              BarChartData(
                barTouchData: barTouchData,
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: barGroups,
                gridData: FlGridData(show: false),
                alignment: BarChartAlignment.spaceAround,
                maxY: weeklyCashback.maxCashbackInWeek,
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          getTooltipItem: (_, __, ___, ____) => BarTooltipItem(
            '',
            const TextStyle(),
          ),
        ),
      );

  List<BarChartGroupData> get barGroups {
    final List<BarChartGroupData> temp = [];
    for (var i = 0; i < weeklyCashback.weeklyCashback.length; i++) {
      temp.insert(
        0,
        _getBarChartRodData(
          index: i,
          amount: weeklyCashback.weeklyCashback[i].amount,
        ),
      );
    }
    return temp;
  }

  BarChartGroupData _getBarChartRodData({
    required int index,
    required double amount,
  }) =>
      BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: amount + 1,
            color: index == 0 ? ControlColors.primaryActive : TextColors.hint,
            width: 10.0,
            borderRadius: const BorderRadius.all(
              Radius.circular(2.0),
            ),
          )
        ],
      );
}
