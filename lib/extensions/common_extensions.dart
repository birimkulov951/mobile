import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/model/payment/pay_params.dart';
import 'package:mobile_ultra/net/payment/model/pynetid.dart';
import 'package:mobile_ultra/screens/main/payments/unique_payment_forms/book_fund/book_fund_widget.dart';
import 'package:mobile_ultra/screens/main/payments/unique_payment_forms/gnk/gnk.dart';
import 'package:mobile_ultra/screens/main/payments/unique_payment_forms/mib_bpi/mib_bpi.dart';
import 'package:mobile_ultra/screens/main/payments/v2/most_common_payment_page.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/utils/PaymentType.dart';

extension CommonStringFunc on String {
  String capitalize() {
    if (this.isEmpty) return this;
    if (this.length == 1) return toUpperCase();
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

extension PaymentNavigation on State {
  Future<dynamic> launchPaymentPage({
    required PaymentParams paymentParams,
  }) async {
    /// TODO может ли быть null?
    if (paymentParams.merchant == null) {
      await showDialog(
          context: context,
          builder: (context) => showMessage(
              context,
              locale.getText('attention'),
              locale.getText('service_not_available'),
              onSuccess: () => Navigator.pop(context)));
      return null;
    }

    if (paymentParams.paymentType != PaymentType.NEW_TEMPLATE) {
      return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => getUniquePaymentWidget(paymentParams)),
      );
    } else {
      return paymentParams.merchant;
    }
  }
}

//Todo will be removed
extension CommonNavigationFunc on State {
  Future<dynamic> launchPaymentForm({
    MerchantEntity? merchant,
    required PaymentType type,
    String title = '',
    PynetId? account,
    String? qrQuery,
    bool autoInfoRequest = false,
  }) async {
    if (merchant == null) {
      await showDialog(
          context: context,
          builder: (context) => showMessage(
              context,
              locale.getText('attention'),
              locale.getText('service_not_available'),
              onSuccess: () => Navigator.pop(context)));

      return null;
    }

    if (type != PaymentType.ADD_NEW_REMINDER) {
      return await Navigator.pushNamed(context, _widgetTag(merchant.id),
          arguments: [
            title,
            merchant,
            account,
            type,
            qrQuery,
            autoInfoRequest
          ]);
    } else
      return merchant.id;
  }
}

//Todo will be removed
extension CommonNavigationFunc2 on StatelessWidget {
  Future<dynamic> launchPaymentForm({
    required context,
    required MerchantEntity? merchant,
    required PaymentType type,
    String title = '',
    PynetId? account,
    String? qrQuery,
    bool autoInfoRequest = false,
  }) async {
    if (merchant == null) {
      await showDialog(
          context: context,
          builder: (context) => showMessage(
              context,
              locale.getText('attention'),
              locale.getText('service_not_available'),
              onSuccess: () => Navigator.pop(context)));

      return null;
    }

    if (type != PaymentType.ADD_NEW_REMINDER) {
      return await Navigator.pushNamed(context, _widgetTag(merchant.id),
          arguments: [
            title,
            merchant,
            account,
            type,
            qrQuery,
            autoInfoRequest
          ]);
    } else
      return merchant.id;
  }
}

Widget getUniquePaymentWidget(
  PaymentParams paymentParams,
) {
  switch (paymentParams.merchant?.id) {
    case 3469:
    case 6070:
      return GNKPaymentWidget(paymentParams: paymentParams);
    case 7289:
      return BookFundWidget(paymentParams: paymentParams);

    case 9169:
      return MIBBPIWidget(paymentParams: paymentParams);
    default:
      return MostCommonPaymentPage(paymentParams: paymentParams);
  }
}

//Todo will be removed
String _widgetTag(int id) {
  switch (id) {
    case 3469:
    case 6070:
      return GNKPaymentWidget.Tag;
    // case 9549:
    //   return LoanRePaymentWidget.Tag;
    case 7289:
      return BookFundWidget.Tag;
    case 9169:
      return MIBBPIWidget.Tag;
    default:
      return MIBBPIWidget.Tag;
  }
}
