import 'dart:convert';

import 'package:mobile_ultra/main.dart' show getAccessToken;
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/net/http_view.dart';
import 'package:mobile_ultra/utils/const.dart';

class GnkServicesReqObjectsPresenter extends Http with HttpView {
  final Function({String error})? onError;
  final Function({List<int>? services})? onGetServices;

  GnkServicesReqObjectsPresenter({
    this.onError,
    this.onGetServices,
  }) : super(path: 'microservice/api/view/get_tax');

  void getServices() =>
      makeGet(this, header: {Const.AUTHORIZATION: getAccessToken()});

  @override
  void onFail(String error, {String? title, dynamic errorBody}) =>
      onError?.call(error: title ?? error);

  @override
  void onSuccess(body) {
    final List<dynamic> jsonList = jsonDecode(body);
    onGetServices?.call(
      services: List.generate(
        jsonList.length,
        (i) => jsonList[i],
      ),
    );
  }
}
