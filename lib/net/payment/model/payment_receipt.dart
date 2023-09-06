class PaymentReceipt {
  final String? merchant;
  final String? receipt;

  PaymentReceipt({
    this.merchant,
    this.receipt,
  });

  factory PaymentReceipt.fromJson(Map<String, dynamic> json) => PaymentReceipt(
        merchant: json['merchant'],
        receipt: json['receipt'],
      );
}
