import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/extensions/common_extensions.dart';
import 'package:mobile_ultra/model/payment/pay_params.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/categories/fast_pay_categories_screen.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/categories/fast_pay_categories_screen_model.dart';
import 'package:mobile_ultra/screens/main/payments/providers/providers.dart';
import 'package:mobile_ultra/screens/main/payments/v2/payment_result/payment_result.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet.dart';
import 'package:mobile_ultra/utils/PaymentType.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/inject.dart';

abstract class IFastPayCategoriesScreenWidgetModel extends IWidgetModel {
  abstract final TextStyle? appBarTextStyle;

  abstract final StateNotifier<ScrollController> scrollController;

  abstract final paymentCategoryList;

  void onShowProviders(
    String title,
    List<int> categoryId,
    List<int> excludeId,
  );

  void scrollTo(int itemsCount);
}

class FastPayCategoriesScreenWidgetModel
    extends WidgetModel<FastPayCategoriesScreen, FastPayCategoriesScreenModel>
    implements IFastPayCategoriesScreenWidgetModel {
  FastPayCategoriesScreenWidgetModel(FastPayCategoriesScreenModel model)
      : super(model);

  @override
  TextStyle? get appBarTextStyle =>
      Theme.of(context).appBarTheme.titleTextStyle;

  @override
  void onShowProviders(
    String title,
    List<int> categoryId,
    List<int> excludeId,
  ) async {
    if (categoryId.isNotEmpty && categoryId.first < 0) {
      final merchant = model.findMerchant(categoryId.first * -1);

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => getUniquePaymentWidget(
            PaymentParams(
              title: title,
              merchant: merchant,
              paymentType: PaymentType.MAKE_PAY,
              isFastPay: widget.arguments.isFastPay,
            ),
          ),
        ),
      );

      if (result != null) {
        Navigator.pop(context, result);
      }
      return;
    }

    final result = await viewModalSheet<PaymentResultAction>(
      context: context,
      child: ProvidersWidget(
        merchantRepository: inject(),
        title: title,
        categoryId: categoryId,
        excludeId: excludeId,
        paymentType: PaymentType.MAKE_PAY,
        isFastPay: widget.arguments.isFastPay,
      ),
    );

    if (result != null) {
      Navigator.pop(context, result);
    }
  }

  @override
  void scrollTo(int itemsCount) {
    scrollController.value!.animateTo(
      scrollController.value!.offset + (itemsCount * 56),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  get paymentCategoryList => Const.paymentCatList;

  @override
  final StateNotifier<ScrollController> scrollController =
      StateNotifier(initValue: ScrollController());
}

FastPayCategoriesScreenWidgetModel fastPayCategoriesScreenWidgetModelFactory(
        _) =>
    FastPayCategoriesScreenWidgetModel(FastPayCategoriesScreenModel(inject()));
