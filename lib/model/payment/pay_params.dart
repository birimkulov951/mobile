import 'package:mobile_ultra/domain/favorite/favorite.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/interactor/analytics/data/payment_opened_data.dart';
import 'package:mobile_ultra/net/payment/model/paynetid.dart';
import 'package:mobile_ultra/net/payment/model/reminder.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/templates_page.dart';
import 'package:mobile_ultra/utils/PaymentType.dart';

class PaymentParams {

  PaymentParams({
    required this.merchant,
    this.title = '',
    this.account,
    this.favorite,
    this.remider,
    this.paymentType = PaymentType.MAKE_PAY,
    this.deeplink,
    this.startFromInforRequest = false,
    this.isFastPay = false,
    this.templateType = TemplateType.None,
    this.paymentOpenedSource,
  });
  final String title;
  final MerchantEntity? merchant;
  final PaynetId? account;
  final FavoriteEntity? favorite;
  final Reminder? remider;
  final PaymentType paymentType;
  final String? deeplink;
  final bool startFromInforRequest;
  final TemplateType templateType;
  final PaymentOpenedSource? paymentOpenedSource;
  final bool isFastPay;


  PaymentParams copy({
    String? title,
    MerchantEntity? merchant,
    PaynetId? account,
    FavoriteEntity? favorite,
    Reminder? remider,
    PaymentType? paymentType,
    String? deeplink,
    bool? startFromInforRequest,
    TemplateType? templateType,
    PaymentOpenedSource? paymentOpenedSource,
    bool? isFastPay,
  }) =>
      PaymentParams(
        title: title ?? this.title,
        merchant: merchant ?? this.merchant,
        account: account ?? this.account,
        favorite: favorite ?? this.favorite,
        remider: remider ?? this.remider,
        paymentType: paymentType ?? this.paymentType,
        deeplink: deeplink ?? this.deeplink,
        startFromInforRequest:
            startFromInforRequest ?? this.startFromInforRequest,
        templateType: templateType ?? this.templateType,
        paymentOpenedSource: paymentOpenedSource ?? this.paymentOpenedSource,
        isFastPay: isFastPay ?? this.isFastPay,
      );

  @override
  String toString() {
    return 'PaymentParams{title: $title, merchant: $merchant, account: $account, favorite: $favorite, remider: $remider, paymentType: $paymentType, deeplink: $deeplink, startFromInforRequest: $startFromInforRequest, templateType: $templateType, paymentOpenedSource: $paymentOpenedSource}';
  }
}
