import 'dart:convert';

import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/http_view.dart';
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/net/profile/modal/perosnal_data.dart';
import 'package:mobile_ultra/utils/u.dart';

abstract class ProfileView {
  void onProfile({
    bool? isActive,
    String? error,
    MyData? myData,
    dynamic errorBody,
  });
}

class ProfilePresenter extends Http with HttpView {
  final ProfileView view;

  ProfilePresenter(
    String path, {
    required this.view,
  }) : super(path: path);

  factory ProfilePresenter.profileButtonActive(ProfileView view) =>
      ProfilePresenter(
        'uaa/api/identification',
        view: view,
      );

  void getIdentification() => makeGet(
        this,
        header: {Const.AUTHORIZATION: getAccessToken()},
      );

  @override
  void onFail(String error, {String? title, dynamic errorBody}) {
    view.onProfile(
      error: title ?? error,
      errorBody: errorBody,
      isActive: null,
    );
  }

  @override
  void onSuccess(body) {
    final Map<String, dynamic> data = jsonDecode(body);
    MyData? myData;
    if (data['data'] != null) {
      myData = MyData.fromJson(data['data']);
    }
    printLog("isActive -> ${data['success']}");
    view.onProfile(isActive: data['success'], myData: myData);
  }
}
