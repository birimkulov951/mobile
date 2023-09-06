import 'dart:convert';

import 'package:mobile_ultra/main.dart' show accountList, db, getAccessToken;
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/net/http_view.dart';
import 'package:mobile_ultra/net/payment/model/paynetid.dart';
import 'package:mobile_ultra/utils/const.dart';

enum PaynetIdAct {
  NEW_ACCOUNT,
  GET_LIST,
  DELETE,
  REORDER,
  EDIT_ACCOUNT,
}

class PaynetIdPresenter extends Http with HttpView {
  final Function({String error})? onGetPaynetIdList;
  final Function()? onDeleteSuccess;
  final Function(PaynetId)? onEdit;
  final Function(String error, {dynamic errorBody})? onError;

  final PaynetIdAct action;

  PaynetIdPresenter(
    String path, {
    this.action = PaynetIdAct.GET_LIST,
    this.onGetPaynetIdList,
    this.onDeleteSuccess,
    this.onEdit,
    this.onError,
  }) : super(path: path);

  factory PaynetIdPresenter.getList({
    Function({String error})? onGetList,
    Function(String error, {dynamic errorBody})? onError,
  }) =>
      PaynetIdPresenter(
        'microservice/api/paynetId/get',
        onGetPaynetIdList: onGetList,
        onError: onError,
      ).._request();

  factory PaynetIdPresenter.attachAccount({
    required int billId,
    String comment = '',
    Function()? onAttachEvent,
    Function(String error, {dynamic errorBody})? onError,
  }) =>
      PaynetIdPresenter(
        'microservice/api/paynetId/create',
        action: PaynetIdAct.NEW_ACCOUNT,
        onDeleteSuccess: onAttachEvent,
        onError: onError,
      ).._attach(jsonEncode({'id': billId, 'comment': comment}));

  factory PaynetIdPresenter.editAccount({
    required int billId,
    required int id,
    String comment = '',
    Function(PaynetId)? onEdit,
    Function(String error, {dynamic errorBody})? onError,
  }) =>
      PaynetIdPresenter(
        'microservice/api/paynetId/edit',
        action: PaynetIdAct.EDIT_ACCOUNT,
        onEdit: onEdit,
        onError: onError,
      ).._attach(
          jsonEncode({
            'billId': billId,
            'id': id,
            'comment': comment,
          }),
        );

  factory PaynetIdPresenter.delete({
    required List<String> params,
    Function()? onDeleteSuccess,
    Function(String error, {dynamic errorBody})? onError,
  }) =>
      PaynetIdPresenter(
        'microservice/api/paynetId/delete/',
        action: PaynetIdAct.DELETE,
        onDeleteSuccess: onDeleteSuccess,
        onError: onError,
      ).._request(params: params);

  factory PaynetIdPresenter.dragAndDrop({
    required List<String> params,
    Function(String error, {dynamic errorBody})? onError,
  }) =>
      PaynetIdPresenter(
        'microservice/api/paynetId/setOrder/',
        action: PaynetIdAct.REORDER,
        onError: onError,
      ).._request(params: params);

  void _attach(String data) => makePost(
        this,
        header: {Const.AUTHORIZATION: getAccessToken()},
        data: data,
      );

  void _request({List<String>? params}) {
    switch (action) {
      case PaynetIdAct.REORDER:
        makeGet(
          this,
          header: {Const.AUTHORIZATION: getAccessToken()},
          pathSegments: params,
        );
        break;
      case PaynetIdAct.DELETE:
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
      case PaynetIdAct.GET_LIST:
        onGetPaynetIdList?.call(error: title ?? error);
        break;
      default:
        onError?.call(title ?? error);
        break;
    }
  }

  @override
  void onSuccess(body) async {
    switch (action) {
      case PaynetIdAct.DELETE:
      case PaynetIdAct.NEW_ACCOUNT:
        onDeleteSuccess?.call();
        break;
      case PaynetIdAct.GET_LIST:
        final List<PaynetId> result = [];

        (jsonDecode(body) as List<dynamic>)
            .forEach((value) => result.add(PaynetId.fromJson(value)));

        result.removeWhere((paynetId) => paynetId.id == null);

        accountList.clear();
        accountList.addAll(result);

        if (result.isNotEmpty) {
          db?.clearMyAccounts().then((_) =>
              db?.setMyAccounts(result).then((_) => onGetPaynetIdList?.call()));
        } else {
          onGetPaynetIdList?.call();
        }
        break;
      case PaynetIdAct.REORDER:
        break;
      case PaynetIdAct.EDIT_ACCOUNT:
        onEdit?.call(PaynetId.fromJson(jsonDecode(body)));
        break;
    }
  }
}
