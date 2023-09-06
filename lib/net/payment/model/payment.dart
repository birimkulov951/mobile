import 'dart:convert';

import 'package:mobile_ultra/net/payment/model/addition_info.dart';
import 'package:mobile_ultra/net/payment/model/payment_qr.dart';

class Payment {
  final int? id;
  final String? pan;
  final String? tranType;
  final double? amount;
  final String? date7;
  final String? dcreated;
  final String? stan;
  final int? expiry;
  final String? refNum;
  final String? merchantId;
  final String? terminalId;
  final int? currency;
  final int? resp;
  final String? status;
  final String? login;
  final String? card1;
  final String? merchantName;
  final String? account;
  final int? billId;
  final String? merchantHash;
  final int? paynetCode;
  final String? paynetMessage;
  final int? transactionId;
  final String? tranTime;
  final String? paynetReceipt;
  final AdditionInfo? additionInfo;
  final PaymentQr? mobileQrDto;
  final String? humoPaymentRef;
  final String? authActionCode;
  final String? authRefNumber;
  final String? date12;
  final dynamic field48;
  final dynamic field91;
  final String? cardId;
  final String? pan2;
  final String? message;
  final Map<String, dynamic>? paymentReceipt;
  final double? commission;
  final String? fio;
  final int? amountCredit;
  final String? pin;

  Payment({
    this.id,
    this.pan,
    this.tranType,
    this.amount,
    this.date7,
    this.dcreated,
    this.stan,
    this.expiry,
    this.refNum,
    this.merchantId,
    this.terminalId,
    this.currency,
    this.resp,
    this.status,
    this.login,
    this.card1,
    this.merchantName,
    this.account,
    this.billId,
    this.merchantHash,
    this.paynetCode,
    this.paynetMessage,
    this.transactionId,
    this.tranTime,
    this.paynetReceipt,
    this.additionInfo,
    this.mobileQrDto,
    this.humoPaymentRef,
    this.authActionCode,
    this.authRefNumber,
    this.date12,
    this.field48,
    this.field91,
    this.cardId,
    this.pan2,
    this.message,
    this.paymentReceipt,
    this.commission,
    this.fio,
    this.amountCredit,
    this.pin,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json['id'],
        pan: json['pan'],
        tranType: json['tranType'],
        amount: json['amount']?.toDouble(),
        date7: json['date7'],
        dcreated: json['dcreated'],
        stan: json['stan'],
        expiry: json['expiry'],
        refNum: json['refNum'],
        merchantId: json['merchantId'],
        terminalId: json['terminalId'],
        currency: json['currency'],
        resp: json['resp'],
        status: json['status'],
        login: json['login'],
        card1: json['card1'],
        merchantName: json['merchantName'],
        account: json['account'],
        billId: json['billId'],
        merchantHash: json['merchantHash'],
        paynetCode: json['paynetCode'],
        paynetMessage: json['paynetMessage'],
        transactionId: json['transactionId'],
        tranTime: json['tranTime'],
        paynetReceipt: json['paynetReceipt'],
        additionInfo: json['additionalInfo'] == null
            ? AdditionInfo()
            : AdditionInfo.fromJson(json['additionalInfo']),
        mobileQrDto: json['mobileQrDto'] != null
            ? PaymentQr.fromJson(json['mobileQrDto'])
            : null,
        humoPaymentRef: json['humo_payment_ref'],
        authActionCode: json['auth_action_code'],
        authRefNumber: json['auth_ref_number'],
        date12: json['date12'],
        field48: json['field48'],
        field91: json['field91'],
        cardId: json['cardId'],
        pan2: json['pan2'],
        message: json['message'],
        paymentReceipt: json['paymentReceipt'],
        commission: json['commission'],
        fio: json['fio'],
        amountCredit: json['amountCredit'],
        pin: json['pin'],
      );

  bool get isSuccess => resp == 0 && status == 'OK';

  String get additionMessage {
    try {
      if (paynetReceipt == null) {
        throw Exception();
      }

      final Map<String, dynamic> _details =
          jsonDecode(paynetReceipt!)['details'];
      return _details.containsKey('response_text')
          ? _details['response_text']['value']
          : '';
    } on Exception catch (_) {
      return '';
    }
  }

  String get bonus {
    final empty = '';
    try {
      if (additionInfo == null) {
        throw Exception();
      }

      final regExp = RegExp(
        r'\d+',
        multiLine: true,
      );
      final matches = regExp.allMatches(
        additionInfo!.infoTextRu,
      );
      if (matches.length > 0) {
        return matches.first.group(0) ?? empty;
      }
      return empty;
    } on Exception catch (_) {
      return empty;
    }
  }

  double get amountHundredths {
    return (amount ?? 0) / 100;
  }

  @override
  String toString() {
    return 'Payment{id: $id, pan: $pan, tranType: $tranType, amount: $amount,'
        ' date7: $date7, dcreated: $dcreated, stan: $stan, expiry: $expiry, '
        'refNum: $refNum, merchantId: $merchantId, terminalId: $terminalId, '
        'currency: $currency, resp: $resp, status: $status, login: $login, '
        'card1: $card1, merchantName: $merchantName, account: $account, '
        'billId: $billId, merchantHash: $merchantHash, paynetCode: $paynetCode,'
        ' paynetMessage: $paynetMessage, transactionId: $transactionId, '
        'tranTime: $tranTime, paynetReceipt: $paynetReceipt, additionInfo: '
        '$additionInfo, mobileQrDto: $mobileQrDto, date12: $date12, field48: '
        '$field48, field91: $field91, cardId: $cardId, pan2: $pan2, message:'
        ' $message, paymentReceipt: $paymentReceipt, commission: $commission}';
  }
}
