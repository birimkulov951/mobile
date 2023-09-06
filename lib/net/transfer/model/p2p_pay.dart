class P2Pay {
  final int? id;
  final dynamic amount;
  final String? pan1;
  final String? pan2;
  final bool? success;
  final int? status;
  final String? detail;
  final String? title;
  final dynamic amountCredit;
  final String? externalId;
  final String? pan;
  final String? tranType;
  final String? issuedDate;
  final String? dcreated;
  final String? stan;
  final int? expiry;
  final String? refNum;
  final String? merchantId;
  final String? terminalId;
  final int? currency;
  final int? resp;
  final String? login;
  final String? card1;
  final String? card2;
  final String? fio;
  final dynamic commission;
  final String? bankName1;
  final String? bankName2;
  final String? humoPaymentRef;

  P2Pay({
    this.id,
    this.amountCredit,
    this.amount,
    this.pan1,
    this.pan2,
    this.success,
    this.status,
    this.detail,
    this.title,
    this.externalId,
    this.pan,
    this.tranType,
    this.issuedDate,
    this.dcreated,
    this.stan,
    this.expiry,
    this.refNum,
    this.merchantId,
    this.terminalId,
    this.currency,
    this.resp,
    this.login,
    this.card1,
    this.card2,
    this.fio,
    this.commission,
    this.bankName1,
    this.bankName2,
    this.humoPaymentRef,
  });

  factory P2Pay.fromJson(Map<String, dynamic> json) => P2Pay(
        amountCredit: json["amountCredit"],
        amount: json['amount'],
        pan1: json['pan1'],
        pan2: json['pan2'],
        success: json['success'],
        status: json['status'],
        detail: json['detail'] ?? '',
        title: json['title'],
        id: json['id'],
        externalId: json['externalId'],
        pan: json['pan'],
        tranType: json['tranType'],
        issuedDate: json['date7'],
        dcreated: json['dcreated'],
        stan: json['stan'],
        expiry: json['expiry'],
        refNum: json['refNum'],
        merchantId: json['merchantId'],
        terminalId: json['terminalId'],
        currency: json['currency'],
        resp: json['resp'],
        login: json['login'],
        card1: json['card1'],
        card2: json['card2'],
        fio: json['fio'],
        commission: json['commission'],
        bankName1: json['bankName1'],
        bankName2: json['bankName2'],
        humoPaymentRef: json['humo_payment_ref'],
      );

  @override
  String toString() {
    return 'P2Pay{id: $id, amount: $amount, pan1: $pan1, pan2: $pan2, success: $success, status: $status, detail: $detail, title: $title, amountCredit: $amountCredit}';
  }
}
