import 'package:mobile_ultra/main.dart' show getAccessToken;
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/net/http_view.dart';
import 'package:mobile_ultra/utils/const.dart';

class PaymentByRequisitesCheckerPresenter extends Http with HttpView {
  Function({String error, String result})? onGetResult;

  PaymentByRequisitesCheckerPresenter()
      : super(path: 'microservice/api/pynet/rekvizit/check');

  void checkStatus({
    required String transactionId,
    required Function({String error, String result}) onGetResult,
  }) {
    this.onGetResult = onGetResult;

    makeGet(
      this,
      header: {Const.AUTHORIZATION: getAccessToken()},
      params: {
        'transactionId': transactionId,
      },
    );
  }

  @override
  void onFail(String details, {String? title, errorBody}) =>
      onGetResult?.call(error: details);

  @override
  void onSuccess(body) => onGetResult?.call(result: body);
}
