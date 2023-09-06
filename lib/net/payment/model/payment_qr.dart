class PaymentQr {
  num? id;
  num? tranId;
  String? terminalId;
  num? checkId;
  String? fiscalSign;
  String? qrCodeUrl;
  num? totalAmount;
  num? pynetComission;
  num? providerComission;
  num? vat;
  String? paymentType;
  num? cash;
  num? card;
  num? remains;
  String? address;

  PaymentQr({this.qrCodeUrl});

  @override
  String toString() {
    return 'PaymentQr{tranId: $tranId, terminalId: $terminalId, checkId: $checkId, fiscalSign: $fiscalSign, qrCodeUrl: $qrCodeUrl, totalAmount: $totalAmount, pynetComission: $pynetComission, providerComission: $providerComission, vat: $vat, paymentType: $paymentType, cash: $cash, card: $card, remains: $remains, address: $address}';
  }

  factory PaymentQr.fromJson(Map<String, dynamic> json) {
    return PaymentQr(qrCodeUrl: json['qrCodeUrl']);
  }
}
