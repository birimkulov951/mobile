import 'package:json_annotation/json_annotation.dart';

part 'p2p_payment_response.g.dart';

@JsonSerializable()
class P2PPaymentResponse {
  final int id;
  final int amount;
  final int amountCredit;
  final int commission;
  @JsonKey(name: 'pan1')
  final String senderMaskedPan;
  @JsonKey(name: 'pan2')
  final String receiverMaskedPan;
  final bool success;
  @JsonKey(name: 'date7')
  final String issuedDate;

  const P2PPaymentResponse({
    required this.id,
    required this.amount,
    required this.amountCredit,
    required this.commission,
    required this.senderMaskedPan,
    required this.receiverMaskedPan,
    required this.success,
    required this.issuedDate,
  });

  factory P2PPaymentResponse.fromJson(Map<String, dynamic> json) =>
      _$P2PPaymentResponseFromJson(json);
}
