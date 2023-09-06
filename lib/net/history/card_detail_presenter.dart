import 'dart:convert';
import 'package:mobile_ultra/main.dart' show getAccessToken;
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/net/http_view.dart';
import 'package:mobile_ultra/net/payment/model/payment_receipt.dart';
import 'package:mobile_ultra/utils/const.dart';

abstract class CardDetailView {
  void onGetPaymentReceipt({PaymentReceipt receipt, String error});
}

class CardDetailPresenter extends Http with HttpView {
  CardDetailView view;

  CardDetailPresenter(this.view)
      : super(path: 'microservice/api/trans/receipt/');

  void getReceipt(List<String> params) => makeGet(
        this,
        header: {Const.AUTHORIZATION: getAccessToken()},
        pathSegments: params,
      );

  @override
  void onFail(String details, {String? title, errorBody}) =>
      view.onGetPaymentReceipt(error: details);

  @override
  void onSuccess(body) {
    view.onGetPaymentReceipt(
      receipt: PaymentReceipt.fromJson(jsonDecode(body)),
    );
  }
}
