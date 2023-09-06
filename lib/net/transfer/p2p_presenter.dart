import 'dart:convert';

import 'package:mobile_ultra/main.dart' show getAccessToken;
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/net/http_view.dart';
import 'package:mobile_ultra/net/transfer/model/p2p_pay.dart';
import 'package:mobile_ultra/utils/const.dart';

import 'package:mobile_ultra/net/transfer/model/commission_transfer.dart';

class P2Presenter extends Http with HttpView {
  static const CHECK = 0;
  static const TRANSFER = 1;
  static const VERIFY = 2;
  static const COMMISSION = 3;

  final int type;

  void Function(String error, {dynamic errorBody})? onGetError;
  void Function(P2Pay result)? onP2PResult;
  void Function(dynamic result)? onP2PCheckResult;
  void Function(List<CommissionTransfer> result)? onCommissionResult;

  P2Presenter(
    String path, {
    this.onGetError,
    this.onP2PResult,
    this.onP2PCheckResult,
    this.type = CHECK,
    this.onCommissionResult,
  }) : super(path: path);

  factory P2Presenter.check({
    Function(String error, {dynamic errorBody})? onGetError,
    Function(dynamic result)? onP2PCheckResult,
  }) =>
      P2Presenter(
        'microservice/api/p2p/check',
        onGetError: onGetError,
        onP2PCheckResult: onP2PCheckResult,
      );

  factory P2Presenter.checkHumo({
    Function(String error, {dynamic errorBody})? onGetError,
    Function(dynamic result)? onP2PCheckResult,
  }) =>
      P2Presenter(
        'microservice/api/humo/p2p/check',
        onGetError: onGetError,
        onP2PCheckResult: onP2PCheckResult,
      );

  factory P2Presenter.checkToken({
    Function(String error, {dynamic errorBody})? onGetError,
    Function(dynamic result)? onP2PCheckResult,
  }) =>
      P2Presenter(
        'microservice/api/p2p/checkByToken',
        onGetError: onGetError,
        onP2PCheckResult: onP2PCheckResult,
      );

  factory P2Presenter.checkPhone({
    Function(String error, {dynamic errorBody})? onGetError,
    Function(dynamic result)? onP2PCheckResult,
  }) =>
      P2Presenter(
        'microservice/api/p2p/checkLogin',
        onGetError: onGetError,
        onP2PCheckResult: onP2PCheckResult,
      );

  factory P2Presenter.checkCardId({
    Function(String error, {dynamic errorBody})? onGetError,
    Function(dynamic result)? onP2PCheckResult,
  }) =>
      P2Presenter(
        'microservice/api/p2p/checkByCardId',
        onGetError: onGetError,
        onP2PCheckResult: onP2PCheckResult,
      );

  factory P2Presenter.checkByPhoneNumber({
    Function(String error, {dynamic errorBody})? onGetError,
    Function(dynamic result)? onP2PCheckResult,
  }) =>
      P2Presenter(
        'microservice/api/p2p/checkByPhoneNumber',
        onGetError: onGetError,
        onP2PCheckResult: onP2PCheckResult,
      );

  factory P2Presenter.transferByPhone({
    Function(String error, {dynamic errorBody})? onGetError,
    Function(dynamic result)? onP2PCheckResult,
  }) =>
      P2Presenter(
        'microservice/api/p2p/createTransferByLogin',
        onGetError: onGetError,
        onP2PCheckResult: onP2PCheckResult,
      );

  factory P2Presenter.transferV3({
    Function(String error, {dynamic errorBody})? onGetError,
    Function(P2Pay result)? onP2PResult,
  }) =>
      P2Presenter(
        'microservice/api/p2p/v3/payment',
        onGetError: onGetError,
        onP2PResult: onP2PResult,
        type: TRANSFER,
      );

  factory P2Presenter.p2pByLogin({
    Function(String error, {dynamic errorBody})? onGetError,
    Function(P2Pay result)? onP2PResult,
  }) =>
      P2Presenter(
        'microservice/api/p2p/p2pByLogin/pay',
        onGetError: onGetError,
        onP2PResult: onP2PResult,
        type: TRANSFER,
      );

  factory P2Presenter.verifyP2P({
    Function(String error, {dynamic errorBody})? onGetError,
    Function(dynamic result)? onP2PCheckResult,
  }) =>
      P2Presenter(
        'microservice/api/p2p/verifyP2pByLogin',
        onGetError: onGetError,
        onP2PCheckResult: onP2PCheckResult,
        type: VERIFY,
      );

  factory P2Presenter.verifySMSP2PByLogin({
    Function(String error, {dynamic errorBody})? onGetError,
    Function(dynamic result)? onP2PCheckResult,
  }) =>
      P2Presenter(
        'microservice/api/p2p/verifySmsP2pByLogin',
        onGetError: onGetError,
        onP2PCheckResult: onP2PCheckResult,
      );

  factory P2Presenter.commissionGet({
    Function(String error, {dynamic errorBody})? onGetError,
    Function(List<CommissionTransfer> result)? onCommissionResult,
  }) =>
      P2Presenter('microservice/api/cards/p2p/commissions',
          onGetError: onGetError,
          onCommissionResult: onCommissionResult,
          type: COMMISSION);

  void makeCheck() =>
      makeGet(this, header: {Const.AUTHORIZATION: getAccessToken()});

  void execute(dynamic data) => makePost(this,
      header: {Const.AUTHORIZATION: getAccessToken()}, data: jsonEncode(data));

  @override
  void onFail(String details, {String? title, dynamic errorBody}) =>
      onGetError?.call(
        details,
        errorBody: errorBody,
      );

  @override
  void onSuccess(body) {
    switch (type) {
      case CHECK:
        onP2PCheckResult?.call(jsonDecode(body));
        break;
      case TRANSFER:
        onP2PResult?.call(P2Pay.fromJson(jsonDecode(body)));
        break;
      case VERIFY:
        onP2PCheckResult?.call('success');
        break;
      case COMMISSION:
        List<dynamic> commissionList = jsonDecode(body);

        onCommissionResult?.call(List.generate(commissionList.length,
            (index) => CommissionTransfer.fromJson(commissionList[index])));
        break;
    }
  }
}
