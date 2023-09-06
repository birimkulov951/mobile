import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/net/http_view.dart';
import 'package:mobile_ultra/utils/const.dart';

const _deleteProfile = 0;

abstract class DeleteView {
  void onError(String? error, {errorBody});
  void onSuccess({dynamic result});
}

class QaPresenter extends Http with HttpView {
  final DeleteView view;
  final int type;

  QaPresenter(
    String path, {
    required this.view,
    required this.type,
  }) : super(path: path);

  factory QaPresenter.deleteProfile(DeleteView view) => QaPresenter(
        'uaa/api/profile',
        view: view,
        type: _deleteProfile,
      );

  void deleteProfile() => makeDelete(
        this,
        header: {Const.AUTHORIZATION: getAccessToken()},
      );

  @override
  void onFail(String details, {String? title, errorBody}) =>
      view.onError(title ?? details, errorBody: errorBody);

  @override
  void onSuccess(body) => view.onSuccess(result: body);
}
