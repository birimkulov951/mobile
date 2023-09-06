class PynetId {
  final int? merchantId;
  final String? merchantName;

  final int? id;
  final String? updateTime;
  final String? account;
  final String? comment;
  final double? lastBalance;
  final int? balanceType;
  final int? order;

  bool? checked;

  final Map<String, dynamic>? payBill;

  PynetId({
    this.merchantId,
    this.merchantName,
    this.id,
    this.updateTime,
    this.account,
    this.comment,
    this.lastBalance,
    this.balanceType,
    this.order,
    this.payBill,
    this.checked = false,
  });

  factory PynetId.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> payId = json['pynetId'];
    return PynetId(
        merchantId: json['merchantId'],
        merchantName: json['merchantName'],
        id: payId['id'],
        updateTime: payId['updateTime'],
        account: payId['account'],
        comment: payId['comment'],
        lastBalance: payId['lastBalance']?.toDouble() ?? 0,
        balanceType: payId['balanceType'],
        order: payId['order'],
        payBill: json['payBill']);
  }

  @override
  String toString() {
    return 'PynetId{merchantId: $merchantId, merchantName: $merchantName, id: $id, updateTime: $updateTime, account: $account, comment: $comment, lastBalance: $lastBalance, balanceType: $balanceType, order: $order, checked: $checked, payBill: $payBill}';
  }
}
