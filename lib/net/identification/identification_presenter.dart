import 'dart:convert';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/http_view.dart';
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/net/identification/modal/passport_data.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/u.dart';

abstract class IdentificationView {
  void onIdentification({
    bool status,
    // List<HistoryResponse> history,
    String error,
    dynamic errorBody,
  });
}

class IdentificationPresenter extends Http with HttpView {
  final IdentificationView view;

  IdentificationPresenter(
    String path, {
    required this.view,
  }) : super(path: path);

  factory IdentificationPresenter.identification(IdentificationView view) =>
      IdentificationPresenter(
        'uaa/api/identification',
        view: view,
      );

  void postPassportData({required PassportData passportData}) => makePost(this,
      header: {Const.AUTHORIZATION: getAccessToken()},
      data: jsonEncode(passportData.toJson()));

  @override
  void onFail(String error, {String? title, dynamic errorBody}) {
    printLog("onFail $error ${errorBody}");

    view.onIdentification(
        error: title ?? error, errorBody: errorBody, status: false);
  }

  @override
  void onSuccess(body) {
    view.onIdentification(status: true);
  }
}
