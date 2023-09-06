import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:mobile_ultra/main.dart' show getAccessToken;
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/net/http_view.dart';
import 'package:mobile_ultra/utils/const.dart';

class AttachPaynetIdPresenter extends Http with HttpView {
  final ValueChanged<String?> onAttachEvent;

  AttachPaynetIdPresenter(this.onAttachEvent)
      : super(path: 'microservice/api/paynetId/create');

  factory AttachPaynetIdPresenter.attach(
    int billId, {
    String comment = '',
    required ValueChanged<String?> onAttachEvent,
  }) =>
      AttachPaynetIdPresenter(
        onAttachEvent,
      ).._attach(jsonEncode({'id': billId, 'comment': comment}));

  // adding new account
  void _attach(String data) => makePost(this,
      header: {Const.AUTHORIZATION: getAccessToken()}, data: data);

  @override
  void onFail(String error, {String? title, dynamic errorBody}) =>
      onAttachEvent(title ?? error);

  @override
  void onSuccess(body) => onAttachEvent(null);
}
