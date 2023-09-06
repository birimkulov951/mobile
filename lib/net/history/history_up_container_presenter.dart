import 'dart:convert';

import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/http_view.dart';
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/u.dart';

abstract class HistoryUpnView {
  void onMonthDebitSum({
    num debidSum,
    String error,
    dynamic errorBody,
  });
}

class HistoryUpPresenter extends Http with HttpView {
  final HistoryUpnView view;

  HistoryUpPresenter(String path, {required this.view}) : super(path: path);

  factory HistoryUpPresenter.debidSum(HistoryUpnView view) =>
      HistoryUpPresenter(
        'microservice/api/trans/sum',
        view: view,
      );

  void getDebidSum() => makeGet(
        this,
        header: {Const.AUTHORIZATION: getAccessToken()},
      );

  @override
  void onFail(String error, {String? title, dynamic errorBody}) {
    view.onMonthDebitSum(
      error: title ?? error,
      errorBody: errorBody,
    );
    printLog("$errorBody $title $error DEBIDSUM");
  }

  @override
  void onSuccess(body) {
    dynamic debidSum = json.decode(body);
    view.onMonthDebitSum(debidSum: debidSum);
  }
}
