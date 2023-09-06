import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/cards_by_phone_number/cards_by_phone_number_entity.dart';
import 'package:mobile_ultra/domain/common/p2p_check_type.dart';
import 'package:mobile_ultra/extensions/iterable_extension.dart';
import 'package:mobile_ultra/main.dart' show db, locale;
import 'package:mobile_ultra/net/card/main_presenter.dart';
import 'package:mobile_ultra/net/card/model/card_been.dart';
import 'package:mobile_ultra/net/transfer/model/commission_transfer.dart';
import 'package:mobile_ultra/net/transfer/model/p2p_check.dart';
import 'package:mobile_ultra/net/transfer/model/p2p_pay.dart';
import 'package:mobile_ultra/net/transfer/p2p_presenter.dart';
import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/u.dart';

abstract class BaseTransferMoneyNew<T extends StatefulWidget>
    extends BaseInheritedTheme<T> {
  P2PCheck? p2pResult;

  String? receiverCardID, receiverToken, receiverCardNumber, receiverPhone;
  int? receiverCardType;

  List<CardBean> beans = [];
  List<CommissionTransfer> commissionList = [
    CommissionTransfer(sender: 4, receiver: 4, commission: .1),
    CommissionTransfer(sender: 1, receiver: 4, commission: .5),
    CommissionTransfer(sender: 4, receiver: 1, commission: .5),
    CommissionTransfer(sender: 1, receiver: 1, commission: .5),
    CommissionTransfer(sender: 5, receiver: 5, commission: .0),
    CommissionTransfer(sender: 1, receiver: 5, commission: .0),
    CommissionTransfer(sender: 4, receiver: 5, commission: .0),
    CommissionTransfer(sender: 5, receiver: 1, commission: 1),
    CommissionTransfer(sender: 5, receiver: 4, commission: 1),
  ];

  @override
  void initState() {
    super.initState();
    db?.readCardBeans().then((cardBeans) {
      if (cardBeans.isEmpty)
        MainPresenter.getCardBeans(onSuccess: (result) {
          if (result != null) {
            beans.addAll(result);
          }
        });
      else
        beans.addAll(cardBeans);
    });
  }

  @override
  void dispose() {
    beans.clear();

    super.dispose();
  }

  /// P2PCheck. Запрашивает информацию о получателе, мин/макс сумму перевода, расчитанную комиссию,
  /// если была указана сумма, процент комисии, переводимую сумму без комиссии, сумму с комисиией.
  ///
  /// • cardType - тип карты отправител;
  ///
  /// • amount - переводимая сумма;
  ///
  /// • comment - комментарий
  ///
  /// • senderToken - токен карты отправителя
  void p2pCheck({
    int? cardType,
    String? senderToken,
    int? receiverCardTypes,
    int? amount,
    String? comment,
    String? cardsNumb,
    BankCardEntity? bankCardEntity,
  }) {
    if (receiverPhone != null) {
      P2Presenter.checkPhone(
              onGetError: onError, onP2PCheckResult: onP2PCheckResult)
          .execute({"id": receiverPhone, "type": "PHONE"});
      return;
    }

    Map<String, dynamic> request = {};

    if (bankCardEntity != null) {
      request["bankName"] = bankCardEntity.bank.bankName;
      request["id"] = bankCardEntity.id;
      request["fullName"] = bankCardEntity.fullName;
      request["cardType"] = bankCardEntity.cardType;
      request["maskedPan"] = bankCardEntity.maskedPan;
      request["exp"] = bankCardEntity.expiry;
      request["amount"] = amount;
      request["type"] = P2PCheckType.phone.value;

      P2Presenter.checkByPhoneNumber(
        onGetError: onError,
        onP2PCheckResult: onP2PCheckResult,
      ).execute(request);
      return;
    }

    request["id"] =
        receiverToken ?? receiverCardID ?? receiverCardNumber ?? cardsNumb;

    if (receiverToken != null) {
      /// TODO разобраться в работе строки ниже
      /// Const.HUMO ?? Const.WALLET
      request["type"] =
          receiverCardType != Const.HUMO ? P2PCheckType.cardToken.value : null;
      request["senderCardType"] = cardType;
      request["receiverCardType"] = receiverCardTypes ?? receiverCardType;
    } else {
      request["type"] = receiverCardID != null
          ? P2PCheckType.cardId.value
          : P2PCheckType.pan.value;
      request["senderCardType"] = cardType;
      receiverCardType = _getCardTypeByPan(receiverCardNumber);
      request["receiverCardType"] = receiverCardTypes ?? receiverCardType;
    }

    request["senderToken"] = senderToken;
    request["amount"] = amount;
    request["comment"] = comment;

    request.removeWhere((key, value) => value == null);

    if (receiverToken != null) {
      final P2Presenter p2pCheck;
      if (receiverCardType == Const.HUMO || receiverCardTypes == Const.HUMO) {
        p2pCheck = P2Presenter.checkHumo(
          onGetError: onError,
          onP2PCheckResult: onP2PCheckResult,
        );
      } else {
        p2pCheck = P2Presenter.checkToken(
          onGetError: onError,
          onP2PCheckResult: onP2PCheckResult,
        );
      }
      p2pCheck.execute(request);
      return;
    }

    if (receiverCardID == null && receiverCardType == Const.HUMO ||
        receiverCardID == null && receiverCardTypes == Const.HUMO) {
      P2Presenter.checkHumo(
              onGetError: onError, onP2PCheckResult: onP2PCheckResult)
          .execute(request);
      return;
    }

    final p2p = receiverCardID != null
        ? P2Presenter.checkCardId(
            onGetError: onError,
            onP2PCheckResult: onP2PCheckResult,
          )
        : P2Presenter.check(
            onGetError: onError,
            onP2PCheckResult: onP2PCheckResult,
          );

    p2p.execute(request);
  }

  void repeatP2pPhoneOnly(String? phoneNumber) {
    if (phoneNumber != null) {
      P2Presenter.checkPhone(
        onGetError: onError,
        onP2PCheckResult: changeHistoryIDForTransfer,
      ).execute({
        'id': phoneNumber,
        'type': 'PHONE',
      });
    }
  }

  void changeHistoryIDForTransfer(dynamic result) {
    this.p2pResult = P2PCheck.fromJson(result);
  }

  int? _getCardTypeByPan(String? cardNumber) {
    if (cardNumber == null) {
      return null;
    }

    if (cardNumber.length >= 4) {
      final cardBean = beans.firstWhereOrNull(
        (bean) => bean.bean == null ? false : cardNumber.startsWith(bean.bean!),
      );

      return cardBean?.cardType ?? null;
    }
    return null;
  }

  /// Выполнение перевода
  ///
  /// • токен карты списания;
  ///
  /// • тип карты списания
  void attemptTransfer({
    String? cardToken,
    int? cardType,
    int? amount,
    String? receiverCardIdentifier,
  }) {
    final Map<String, dynamic> request = {};
    request['amount'] = amount;
    request['id1'] = cardToken;
    request['type1'] = 'CARD_TOKEN';
    request['senderCardType'] = cardType;
    request['receiverCardType'] =
        p2pResult?.receiverCardType ?? _getCardTypeByPan(p2pResult?.pan);

    request['id2'] = receiverCardIdentifier ??
        p2pResult?.cardID ??
        p2pResult?.byToken ??
        p2pResult?.pan;
    request['type2'] = p2pResult?.p2pCheckType.value;
    request['receiverBankName'] = p2pResult?.receiverBankName;

    request['fio'] = p2pResult?.fio;
    request['exp'] = p2pResult?.exp?.length == 6
        ? p2pResult?.exp?.substring(2)
        : p2pResult?.exp;
    request['comment'] = p2pResult?.comment;

    request.removeWhere((key, value) => value == null);
    final v3 = P2Presenter.transferV3(
      onGetError: onError,
      onP2PResult: onP2PResult,
    );
    v3.execute(request);
    printLog(request);
  }

  void createTransferByPhone({
    String? cardToken,
    String? phone,
    int? amount,
    String? comment,
    dynamic phoneHistoryId,
  }) {
    Map<String, dynamic> requestBody = {};

    requestBody['id'] = phoneHistoryId;
    requestBody['payerToken'] = cardToken;
    requestBody['amount'] = amount;
    requestBody['payeeLogin'] = phone;
    requestBody['comment'] = comment;

    P2Presenter.transferByPhone(
            onGetError: onError, onP2PCheckResult: onP2PCheckResult)
        .execute(requestBody);
  }

  void commissionGet() {
    P2Presenter.commissionGet(
            onGetError: onError, onCommissionResult: onP2PCommissionResult)
        .makeCheck();
  }

  void verifyP2PBySmsCode({
    required String id,
    required String code,
    required int historyId,
  }) =>
      P2Presenter.verifySMSP2PByLogin(
              onGetError: onError, onP2PCheckResult: onP2PCheckResult)
          .execute({
        'id': id,
        'otp': code,
        'requestId': historyId,
      });

  Future onError(String error, {dynamic errorBody}) async => await showDialog(
      context: context,
      builder: (BuildContext context) => showMessage(
          context, locale.getText('error'), error,
          onSuccess: () => Navigator.pop(context)));

  void onP2PCheckResult(dynamic result) {
    this.p2pResult = P2PCheck.fromJson(result);
  }

  void onP2PCommissionResult(List<CommissionTransfer> results) {
    if (results.isNotEmpty) {
      commissionList.clear();
      commissionList.addAll(results);
    }
  }

  void onP2PResult(P2Pay result) {}
}
