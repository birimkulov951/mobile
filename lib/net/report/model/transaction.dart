import 'package:mobile_ultra/net/payment/model/addition_info.dart';
import 'package:mobile_ultra/net/payment/model/payment_qr.dart';

class Transaction {
  final int? id;
  final double? amountCredit;
  double? amount;
  final String? card1;
  final String? card2;
  final String? date12;
  String? date7;
  final int? expiry;
  final String? field48;
  final String? field91;
  final String? login;
  final String? merchantId;
  final String? merchantName;
  final String? merchantHash;
  final String? pan;
  final String? pan2;
  final String? refNum;
  final String? account;
  final int? resp;
  final String? stan;
  final String? status;
  final String? terminalId;
  final String? tranType;
  final dynamic billId;
  final dynamic pynetCode;
  final dynamic pynetMessage;
  final String? fio;
  final double? commission;
  String? pynetReceipt;
  final Map<String, dynamic>? paymentReceipt;
  final AdditionInfo? additionInfo;
  bool? isTrack;
  final String? comment;
  final PaymentQr? mobileQrDto;

  Transaction({
    this.id,
    this.amountCredit,
    this.amount,
    this.card1,
    this.card2,
    this.date12,
    this.date7,
    this.expiry,
    this.field48,
    this.field91,
    this.login,
    this.merchantId,
    this.merchantName,
    this.merchantHash,
    this.pan,
    this.pan2,
    this.refNum,
    this.account,
    this.resp,
    this.stan,
    this.status,
    this.terminalId,
    this.tranType,
    this.billId,
    this.pynetCode,
    this.pynetMessage,
    this.fio,
    this.commission,
    this.pynetReceipt,
    this.paymentReceipt,
    this.additionInfo,
    this.isTrack = false,
    this.comment,
    this.mobileQrDto,
  });

  Transaction copy() {
    return Transaction(
      id: id,
      amountCredit: amountCredit,
      amount: amount,
      card1: card1,
      card2: card2,
      date12: date12,
      date7: date7,
      expiry: expiry,
      field48: field48,
      field91: field91,
      login: login,
      merchantId: merchantId,
      merchantName: merchantName,
      merchantHash: merchantHash,
      pan: pan,
      pan2: pan2,
      refNum: refNum,
      account: account,
      resp: resp,
      stan: stan,
      status: status,
      terminalId: terminalId,
      tranType: tranType,
      billId: billId,
      pynetCode: pynetCode,
      pynetMessage: pynetMessage,
      fio: fio,
      commission: commission,
      pynetReceipt: pynetReceipt,
      paymentReceipt: paymentReceipt,
      additionInfo: additionInfo,
      isTrack: isTrack,
      comment: comment,
      mobileQrDto: mobileQrDto,
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json, bool isTrack) =>
      Transaction(
        id: json['id'],
        amountCredit: (json['amountCredit'] ?? 0) / 100,
        amount: (json['amount'] ?? 0) / 100,
        card1: json['card1'],
        card2: json['card2'] ?? '',
        date12: json['date12'],
        date7: json['date7'],
        expiry: json['expiry'],
        field48: json['field48'],
        field91: json['field91'],
        login: json['login'],
        merchantId: json['merchantId'],
        merchantName: json['merchantName'] ?? '',
        merchantHash: json['merchantHash'] ?? '-1',
        pan: json['pan'] ?? '',
        pan2: json['pan2'] ?? '',
        refNum: json['refNum'],
        account: json['account'] ?? '',
        resp: json['resp'] ?? -1,
        stan: json['stan'],
        status: json['status'],
        terminalId: json['terminalId'] ?? '',
        tranType: json['tranType'],
        billId: json['billId'],
        pynetCode: json['pynetCode'],
        pynetMessage: json['pynetMessage'],
        fio: json['fio'] ?? '',
        commission: (json['commission'] ?? 0) / 100,
        pynetReceipt: json['pynetReceipt'],
        paymentReceipt: json['paymentReceipt'],
        additionInfo: json['additionalInfo'] == null
            ? AdditionInfo()
            : AdditionInfo.fromJson(json['additionalInfo']),
        isTrack: isTrack,
        comment: json['comment'] ?? '',
        mobileQrDto: json['mobileQrDto'] != null
            ? PaymentQr.fromJson(json['mobileQrDto'])
            : null,
      );

  bool get isSuccess => resp == 0 && status == "OK";

  @override
  String toString() {
    return 'Transaction{amount: $amount, date: $date7}';
  }
}
