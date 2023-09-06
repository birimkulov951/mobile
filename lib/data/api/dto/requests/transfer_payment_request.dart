import 'package:json_annotation/json_annotation.dart';

part 'transfer_payment_request.g.dart';

//V2, V3
@JsonSerializable()
class TransferPaymentRequest {
  @JsonKey(name: 'id1')
  final String senderToken;
  @JsonKey(name: 'type1')
  final String senderMethodType;
  final int senderCardType;

  @JsonKey(name: 'id2')
  final String receiverToken;
  @JsonKey(name: 'type2')
  final String receiverMethodType;
  final int receiverCardType;
  final String? receiverBankName;

  final int amount;
  final String fio;
  final String? exp;

  const TransferPaymentRequest({
    required this.senderToken,
    required this.senderMethodType,
    required this.senderCardType,
    required this.receiverToken,
    required this.receiverMethodType,
    required this.receiverCardType,
    required this.amount,
    required this.fio,
    required this.exp,
    required this.receiverBankName,
  });

  Map<String, dynamic> toJson() => _$TransferPaymentRequestToJson(this);
}
