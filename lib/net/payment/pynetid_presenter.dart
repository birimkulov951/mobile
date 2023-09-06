import 'dart:convert';

import 'package:mobile_ultra/main.dart' show accountList, db, getAccessToken;
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/net/http_view.dart';
import 'package:mobile_ultra/net/payment/model/pynetid.dart';
import 'package:mobile_ultra/utils/const.dart';

enum PynetIdAct {
  NEW_ACCOUNT,
  GET_LIST,
  DELETE,
  REORDER,
  EDIT_ACCOUNT,
}

class PynetIdPresenter extends Http with HttpView {
  final Function({String error})? onGetPynetIdList;
  final Function()? onDeleteSuccess;
  final Function(PynetId)? onEdit;
  final Function(String error, {dynamic errorBody})? onError;

  final PynetIdAct action;

  PynetIdPresenter(
    String path, {
    this.action = PynetIdAct.GET_LIST,
    this.onGetPynetIdList,
    this.onDeleteSuccess,
    this.onEdit,
    this.onError,
  }) : super(path: path);

  factory PynetIdPresenter.getList({
    Function({String error})? onGetList,
    Function(String error, {dynamic errorBody})? onError,
  }) =>
      PynetIdPresenter(
        'microservice/api/PynetId/get',
        onGetPynetIdList: onGetList,
        onError: onError,
      ).._request();

  factory PynetIdPresenter.attachAccount({
    required int billId,
    String comment = '',
    Function()? onAttachEvent,
    Function(String error, {dynamic errorBody})? onError,
  }) =>
      PynetIdPresenter(
        'microservice/api/PynetId/create',
        action: PynetIdAct.NEW_ACCOUNT,
        onDeleteSuccess: onAttachEvent,
        onError: onError,
      ).._attach(jsonEncode({'id': billId, 'comment': comment}));

  factory PynetIdPresenter.editAccount({
    required int billId,
    required int id,
    String comment = '',
    Function(PynetId)? onEdit,
    Function(String error, {dynamic errorBody})? onError,
  }) =>
      PynetIdPresenter(
        'microservice/api/PynetId/edit',
        action: PynetIdAct.EDIT_ACCOUNT,
        onEdit: onEdit,
        onError: onError,
      ).._attach(
          jsonEncode({
            'billId': billId,
            'id': id,
            'comment': comment,
          }),
        );

  factory PynetIdPresenter.delete({
    required List<String> params,
    Function()? onDeleteSuccess,
    Function(String error, {dynamic errorBody})? onError,
  }) =>
      PynetIdPresenter(
        'microservice/api/PynetId/delete/',
        action: PynetIdAct.DELETE,
        onDeleteSuccess: onDeleteSuccess,
        onError: onError,
      ).._request(params: params);

  factory PynetIdPresenter.dragAndDrop({
    required List<String> params,
    Function(String error, {dynamic errorBody})? onError,
  }) =>
      PynetIdPresenter(
        'microservice/api/PynetId/setOrder/',
        action: PynetIdAct.REORDER,
        onError: onError,
      ).._request(params: params);

  void _attach(String data) => makePost(
        this,
        header: {Const.AUTHORIZATION: getAccessToken()},
        data: data,
      );

  void _request({List<String>? params}) {
    switch (action) {
      case PynetIdAct.REORDER:
        makeGet(
          this,
          header: {Const.AUTHORIZATION: getAccessToken()},
          pathSegments: params,
        );
        break;
      case PynetIdAct.DELETE:
        makeDelete(
          this,
          header: {Const.AUTHORIZATION: getAccessToken()},
          params: params,
        );
        break;
      default:
        makeGet(
          this,
          header: {Const.AUTHORIZATION: getAccessToken()},
        );
        break;
    }
  }

  @override
  void onFail(String error, {String? title, dynamic errorBody}) {
    switch (action) {
      case PynetIdAct.GET_LIST:
        onGetPynetIdList?.call(error: title ?? error);
        break;
      default:
        onError?.call(title ?? error);
        break;
    }
  }

  @override
  void onSuccess(body) async {
    switch (action) {
      case PynetIdAct.DELETE:
      case PynetIdAct.NEW_ACCOUNT:
        onDeleteSuccess?.call();
        break;
      case PynetIdAct.GET_LIST:
        final List<PynetId> result = [];

        (jsonDecode(body) as List<dynamic>)
            .forEach((value) => result.add(PynetId.fromJson(value)));

        result.removeWhere((PynetId) => PynetId.id == null);

        accountList.clear();
        accountList.addAll(result);

        if (result.isNotEmpty) {
          db?.clearMyAccounts().then((_) =>
              db?.setMyAccounts(result).then((_) => onGetPynetIdList?.call()));
        } else {
          onGetPynetIdList?.call();
        }
        break;
      case PynetIdAct.REORDER:
        break;
      case PynetIdAct.EDIT_ACCOUNT:
        onEdit?.call(PynetId.fromJson(jsonDecode(body)));
        break;
    }
  }
}
