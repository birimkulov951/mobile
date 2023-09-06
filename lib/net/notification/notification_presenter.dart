import 'dart:convert';
import 'package:mobile_ultra/main.dart' show getAccessToken;
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/net/http_view.dart';
import 'package:mobile_ultra/net/notification/modal/notification.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:intl/intl.dart';

abstract class NotificationView {
  void onNotification({
    List<NotificationResponse> notification,
    String error,
    dynamic errorBody,
  });
}

class NotificationPresenter extends Http with HttpView {
  final NotificationView view;

  NotificationPresenter(String path, {required this.view}) : super(path: path);

  factory NotificationPresenter.notification(NotificationView view) =>
      NotificationPresenter(
        'uaa/api/account/news',
        view: view,
      );

  void get() => makeGet(
        this,
        header: {Const.AUTHORIZATION: getAccessToken()},
      );

  void getTransfer() => makeGet(
        this,
        header: {Const.AUTHORIZATION: getAccessToken()},
        params: {
          "date7.greaterThan": DateFormat("yyyy-MM-ddTHH:mm:ss.mmm").format(
                DateTime.now().subtract(Duration(days: 30)),
              ) +
              "Z",
          "date7.lessThan": DateFormat("yyyy-MM-ddTHH:mm:ss.mmm").format(
                DateTime.now().add(Duration(days: 1)),
              ) +
              "Z",
          "page": "0",
          "size": "100",
        },
      );

  @override
  void onFail(String error, {String? title, dynamic errorBody}) =>
      view.onNotification(
        error: title ?? error,
        errorBody: errorBody,
      );

  @override
  void onSuccess(body) {
    Iterable l = json.decode(body);
    List<NotificationResponse> posts = [];
    l.forEach((e) {
      posts.add(NotificationResponse.fromJson(e));
    });
    view.onNotification(notification: posts);
  }
}
