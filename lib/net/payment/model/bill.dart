class Bill {
  final int? id;
  final String? merchantName;
  final int? merchantId;
  final String? account;
  final int? amount;
  final String? paymentDate;
  final String? login;
  final int? status;
  final String? statusMessage;
  final String? requestJson;
  final String? responseJson;
  final String? name;
  final String? requestTime;
  final String? responseTime;
  final int? tranId;

  Bill({
    this.id,
    this.merchantName,
    this.merchantId,
    this.account,
    this.amount,
    this.paymentDate,
    this.login,
    this.status,
    this.statusMessage,
    this.requestJson,
    this.responseJson,
    this.name,
    this.requestTime,
    this.responseTime,
    this.tranId,
  });

  factory Bill.fromJson(Map<String, dynamic> json) => Bill(
        id: json['id'],
        merchantName: json['merchantName'],
        merchantId: json['merchantId'],
        account: json['account'],
        amount: json['amount'],
        paymentDate: json['paymentDate'],
        login: json['login'],
        status: json['status'],
        statusMessage: json['statusMessage'],
        responseJson: json['responseJson'],
        requestJson: json['requestJson'],
        requestTime: json['requestTime'],
        responseTime: json['responseTime'],
        tranId: json['tranId'],
      );
}
