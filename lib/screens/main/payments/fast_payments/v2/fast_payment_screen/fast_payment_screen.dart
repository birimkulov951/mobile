import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';

import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/history/modal/history.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/fast_payment_screen/fast_payment_screen_wm.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/widgets/current_card_container.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/widgets/loading_shimmer/total_spent_shimmer.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/widgets/loading_shimmer/transaction_list_shimmer.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/widgets/most_used_merchants.dart';
import 'package:mobile_ultra/widgets/cell_phone_payment/cell_phone_payment.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/widgets/today_total_spent.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/widgets/transactions_history_list.dart';
import 'package:mobile_ultra/ui_models/app_bar/custom_app_bar.dart';

const _shimmerListLength = 5;

class FastPaymentScreen
    extends ElementaryWidget<IFastPaymentScreenWidgetModel> {
  const FastPaymentScreen({Key? key})
      : super(fastPaymentScreenWidgetModelFactory, key: key);

  @override
  Widget build(IFastPaymentScreenWidgetModel wm) {
    return Scaffold(
      appBar: PaynetAppBar(
        locale.getText('fast_pay_title'),
        centerTitle: false,
      ),
      body: MediaQuery(
        data: wm.mediaQueryData.removePadding(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: EntityStateNotifierBuilder(
                        listenableEntityState: wm.sumOfTodayExpenditure,
                        builder: (_, __) => TodayTotalSpent(
                          totalSpentAmount:
                              wm.sumOfTodayExpenditure.value?.data ?? 0,
                          onTapResetTotalAmount: wm.onTapResetTotalAmount,
                        ),
                        loadingBuilder: (_, double? previousData) {
                          if (previousData != null) {
                            return TodayTotalSpent(
                              totalSpentAmount: previousData,
                              onTapResetTotalAmount: wm.onTapResetTotalAmount,
                            );
                          }
                          return const TotalSpentShimmer();
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: StateNotifierBuilder(
                        listenableState: wm.selectFromCardState,
                        builder: (_, __) => CurrentCardContainer(
                          currentCard: wm.selectFromCardState.value,
                          onTapChooseCard: wm.selectFromCard,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              CellPhonePayment(
                onSuccessPayment: wm.fetchData,
              ),
              SizedBox(height: 12),
              MostUsedMerchants(
                onPressServicePaymentButton: wm.onPressServicePaymentButton,
                onPressMostUsedMerchant: wm.onPressMostUsedMerchant,
              ),
              SizedBox(height: 12),
              EntityStateNotifierBuilder(
                listenableEntityState: wm.lastTransactions,
                builder: (_, List<HistoryResponse>? list) =>
                    TransactionsHistoryList(
                  listOfTransactions: list ?? [],
                  onPressOpenHistory: wm.onPressGoToHistoryButton,
                ),
                loadingBuilder: (_, List<HistoryResponse>? previousData) {
                  if (previousData != null && previousData.isNotEmpty) {
                    return TransactionsHistoryList(
                      listOfTransactions: previousData,
                      onPressOpenHistory: wm.onPressGoToHistoryButton,
                    );
                  }
                  return TransactionListShimmer(
                    shimmerListLength: _shimmerListLength,
                    onPressOpenHistory: wm.onPressGoToHistoryButton,
                  );
                },
              ),
              SizedBox(height: wm.bottomPaddingForScreen),
            ],
          ),
        ),
      ),
    );
  }
}
