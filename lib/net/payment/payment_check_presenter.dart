import 'dart:convert';

import 'package:mobile_ultra/main.dart' show getAccessToken;
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/net/http_view.dart';
import 'package:mobile_ultra/net/payment/model/bill.dart';
import 'package:mobile_ultra/utils/const.dart';

abstract class PaymentCheckView {
  void onCheckComplete({Bill data, String error});
}

class PaymentCheckPresenter extends Http with HttpView {
  final PaymentCheckView view;

  PaymentCheckPresenter(String path, {required this.view}) : super(path: path);

  factory PaymentCheckPresenter.check(PaymentCheckView view) =>
      PaymentCheckPresenter('pms2/api/paynet/act2', view: view);

  factory PaymentCheckPresenter.checkPrepaid(PaymentCheckView view) =>
      PaymentCheckPresenter('microservice/api/paynet/act2prepaid', view: view);

  void makeRequest(String data) => makePost(this,
      header: {Const.AUTHORIZATION: getAccessToken()}, data: data);

  @override
  void onFail(String error, {String? title, dynamic errorBody}) =>
      view.onCheckComplete(error: title ?? error);

  @override
  void onSuccess(body) =>
      view.onCheckComplete(data: Bill.fromJson(jsonDecode(body)));
}
