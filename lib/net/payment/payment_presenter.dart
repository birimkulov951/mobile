import 'dart:convert';

import 'package:mobile_ultra/main.dart' show getAccessToken;
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/net/http_view.dart';
import 'package:mobile_ultra/net/payment/model/payment.dart';
import 'package:mobile_ultra/utils/const.dart';

abstract class PaymentView {
  void onPaid({Payment payment, String error, dynamic errorBody});
}

class PaymentPresenter extends Http with HttpView {
  final PaymentView? view;

  PaymentPresenter(String path, {required this.view}) : super(path: path);

  factory PaymentPresenter.fromUzcard(PaymentView view) => PaymentPresenter(
        'microservice/api/trans/v3/payment',
        view: view,
      );

  factory PaymentPresenter.fromHumo(PaymentView view) => PaymentPresenter(
        'microservice/api/humo/trans/v3/payment',
        view: view,
      );

  factory PaymentPresenter.resendCode(bool isHumo) {
    if (isHumo) {
      return PaymentPresenter(
        'microservice/api/humo/trans/v3/payment',
        view: null,
      );
    } else {
      return PaymentPresenter(
        'microservice/api/trans/v3/payment',
        view: null,
      );
    }
  }

  void pay(dynamic data) => makePost(
        this,
        header: {Const.AUTHORIZATION: getAccessToken()},
        data: jsonEncode(data),
      );

  @override
  void onFail(String error, {String? title, dynamic errorBody}) {
    if (view != null) {
      view!.onPaid(
        error: title ?? error,
        errorBody: errorBody,
      );
    }
  }

  @override
  void onSuccess(body) {
    if (view != null) {
      view!.onPaid(payment: Payment.fromJson(jsonDecode(body)));
    }
  }
}
