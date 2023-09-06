import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/extensions/common_extensions.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/model/payment/pay_params.dart';
import 'package:mobile_ultra/net/history/modal/history.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/base/mwwm/select_card/select_from_card/select_from_card_wm.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/categories/fast_pay_categories_screen.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/categories/route/arguments.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/fast_payment_screen/fast_payment_screen.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/fast_payment_screen/fast_payment_screen_model.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet_dialog.dart';
import 'package:mobile_ultra/ui_models/toast/toast.dart';
import 'package:mobile_ultra/utils/PaymentType.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/inject.dart';

const _historySizeLimit = 5;

abstract class IFastPaymentScreenWidgetModel extends IWidgetModel
    with ISelectFromCardMixin {
  void onTapResetTotalAmount();

  void onPressServicePaymentButton();

  void onPressMostUsedMerchant(int merchantId);

  void onPressGoToHistoryButton();

  void fetchData();

  abstract final EntityStateNotifier<List<HistoryResponse>> lastTransactions;

  abstract final EntityStateNotifier<double> sumOfTodayExpenditure;

  abstract final double bottomPaddingForScreen;

  abstract final MediaQueryData mediaQueryData;
}

class FastPaymentScreenWidgetModel
    extends WidgetModel<FastPaymentScreen, FastPaymentScreenModel>
    with SelectFromCardMixin<FastPaymentScreen, FastPaymentScreenModel>
    implements IFastPaymentScreenWidgetModel {
  FastPaymentScreenWidgetModel(FastPaymentScreenModel model) : super(model);

  @override
  final EntityStateNotifier<List<HistoryResponse>> lastTransactions =
      EntityStateNotifier();

  @override
  double get bottomPaddingForScreen =>
      MediaQuery.of(context).viewPadding.bottom + 16;

  @override
  final EntityStateNotifier<double> sumOfTodayExpenditure =
      EntityStateNotifier();

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    fetchData();
  }

  @override
  void onTapResetTotalAmount() async {
    final result = await viewAndroidModalSheetDialog(
      context: context,
      title: locale.getText('clear_counter'),
      message: locale.getText('clear_counter_details'),
      confirmBtnTitle: locale.getText('reset_expenditure'),
      confirmBtnTextStyle: TextStyles.textMedium.copyWith(color: ColorNode.Red),
      cancelBtnTitle: locale.getText('cancel'),
      cancelBtnTextStyle: TextStyles.textRegularSecondary,
    );
    if (result == true) {
      await _setLastExpenditureResetDate();
      sumOfTodayExpenditure.content(0);
    }
  }

  @override
  void onPressServicePaymentButton() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FastPayCategoriesScreen(
                arguments: FastPayCategoriesScreenArguments(isFastPay: true))));
    if (result != null) {
      _onSuccess();
    }
  }

  @override
  void onPressMostUsedMerchant(int merchantId) async {
    final merchant = model.findMerchant(merchantId);

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => getUniquePaymentWidget(
          PaymentParams(
            title: _getMerchantTitleByMerchantId(merchantId),
            merchant: merchant,
            paymentType: PaymentType.MAKE_PAY,
            isFastPay: true,
          ),
        ),
      ),
    );
    if (result != null) {
      _onSuccess();
    }
  }

  @override
  void onPressGoToHistoryButton() {
    Navigator.pop(context, true);
  }

  @override
  void fetchData() {
    _getTransactionsHistory();
    _getSumOfTodayExpenditure();
  }

  String _getMerchantTitleByMerchantId(int id) {
    switch (id) {
      case 3630:
        return locale.getText('mobile_and_gts');
      default:
        return locale.getText('communal_payments');
    }
  }

  Future<DateTime?> _getLastExpenditureResetDate() async {
    return await model.getLastExpenditureResetDate();
  }

  Future<void> _getTransactionsHistory() async {
    lastTransactions.loading();
    final response =
        await model.getTransactionHistory(locale.prefix, _historySizeLimit);
    lastTransactions.content(response);
  }

  Future<void> _setLastExpenditureResetDate() async {
    return await model.setLastExpenditureResetDate(DateTime.now());
  }

  Future<void> _getSumOfTodayExpenditure() async {
    sumOfTodayExpenditure.loading();
    final currentTime = DateTime.now();
    final lastDate = await _getLastExpenditureResetDate();
    final todayDate =
        DateTime(currentTime.year, currentTime.month, currentTime.day);
    late final response;
    if (lastDate == null || lastDate.isBefore(todayDate)) {
      response = await model.getSumOfTodayExpenditure(todayDate);
    } else {
      response = await model.getSumOfTodayExpenditure(lastDate);
    }
    sumOfTodayExpenditure.content(response);
  }

  void _onSuccess() {
    Toast.show(
      context,
      title: locale.getText('payment_is_successful'),
      type: ToastType.success,
    );

    fetchData();
  }

  @override
  MediaQueryData get mediaQueryData => MediaQuery.of(context);
}

FastPaymentScreenWidgetModel fastPaymentScreenWidgetModelFactory(_) =>
    FastPaymentScreenWidgetModel(FastPaymentScreenModel(inject(), inject()));
