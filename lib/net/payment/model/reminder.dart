class Reminder {
  final int? id;
  final String? createDate;
  final String? login;
  final int? merchantId;
  final String? account;
  final String? requestString;
  final double? amount;
  final int? fireWeekDay;
  final int? fireMonthDay;
  final int? status;
  final String? type;
  final Map<String, dynamic>? payBill;
  final String? finishDate;
  final bool? oneTimeReminder;
  final String? name;

  Reminder({
    this.id,
    this.createDate,
    this.login,
    this.merchantId,
    this.account,
    this.requestString,
    this.amount,
    this.fireWeekDay,
    this.fireMonthDay,
    this.status,
    this.type,
    this.payBill,
    this.finishDate,
    this.oneTimeReminder = false,
    this.name = '',
  });

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
        id: json['id'],
        createDate: json['createDate'],
        merchantId: json['merchantId'],
        account: json['account'],
        requestString: json['requestString'],
        amount: json['amount'].toDouble(),
        fireWeekDay: json['fireWeekDay'],
        fireMonthDay: json['fireMonthDay'],
        status: json['status'],
        type: json['type'],
        payBill: json['payBill'],
        finishDate: json['finishDate'],
        oneTimeReminder: json['oneTimeReminder'],
        name: json['name'] ?? '',
      );

  Map<String, dynamic> get toJson => {
        'id': id,
        'createDate': createDate,
        'merchantId': merchantId,
        'account': account,
        'requestString': requestString,
        'amount': amount,
        'fireWeekDay': fireWeekDay,
        'fireMonthDay': fireMonthDay,
        'status': status,
        'type': type,
        'payBill': payBill,
        'finishDate': finishDate,
        'oneTimeReminder': oneTimeReminder,
      };
}
