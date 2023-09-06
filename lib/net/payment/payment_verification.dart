import 'dart:convert';

import 'package:mobile_ultra/main.dart' show getAccessToken;
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/net/http_view.dart';
import 'package:mobile_ultra/net/payment/model/payment.dart';
import 'package:mobile_ultra/net/transfer/model/p2p_pay.dart';
import 'package:mobile_ultra/utils/const.dart';

abstract class PaymentVerificationView {
  void onPayVerifyError(String error, dynamic errorBody);

  void onPayVerifySuccess(dynamic result);
}

class PaymentVerificationPresenter extends Http with HttpView {
  static const PAYMENT = 0;
  static const P2P = 1;

  final PaymentVerificationView view;
  final int type;

  PaymentVerificationPresenter(String path, this.view,
      {this.type = PaymentVerificationPresenter.PAYMENT})
      : super(path: path);

  factory PaymentVerificationPresenter.verifyUzcard(
    PaymentVerificationView view,
  ) =>
      PaymentVerificationPresenter(
        'microservice/api/trans/v2/verify',
        view,
      );

  factory PaymentVerificationPresenter.verifyHumo(
    PaymentVerificationView view,
  ) =>
      PaymentVerificationPresenter(
        'microservice/api/humo/trans/v2/verify',
        view,
      );

  factory PaymentVerificationPresenter.verifyP2P(
          PaymentVerificationView view) =>
      PaymentVerificationPresenter(
        //'microservice/api/p2p/v2/verify',
        'microservice/api/p2p/v4/verify',
        view,
        type: P2P,
      );

  void verify(dynamic data) => makePost(this,
      header: {Const.AUTHORIZATION: getAccessToken()}, data: jsonEncode(data));

  @override
  void onFail(String details, {String? title, errorBody}) =>
      view.onPayVerifyError(title ?? details, errorBody);

  @override
  void onSuccess(body) {
    switch (type) {
      case PaymentVerificationPresenter.PAYMENT:
        view.onPayVerifySuccess(Payment.fromJson(jsonDecode(body)));
        break;
      case PaymentVerificationPresenter.P2P:
        view.onPayVerifySuccess(P2Pay.fromJson(jsonDecode(body)));
        break;
    }
  }
}
