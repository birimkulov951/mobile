import 'package:json_annotation/json_annotation.dart';

part 'p2p_info_request.g.dart';

@JsonSerializable()
class P2PInfoRequest {
  P2PInfoRequest({
    required this.id,
    required this.type,
    this.amount,
    this.senderCardType,
    this.senderToken,
    this.receiverCardType,
  });

  final String id;
  final String type;

  final int? amount;

  final String? senderToken;

  //тип карты отправителя
  final int? senderCardType;

  // тип карты получателя
  final int? receiverCardType;

  factory P2PInfoRequest.fromJson(Map<String, dynamic> json) =>
      _$P2PInfoRequestFromJson(json);

  Map<String, dynamic> toJson() => _$P2PInfoRequestToJson(this);
}

@JsonSerializable()
class P2PInfoByPhoneNumberRequest {
  P2PInfoByPhoneNumberRequest({
    required this.id,
    required this.bankName,
    required this.fullName,
    required this.cardType,
    required this.maskedPan,
    this.amount,
    this.exp,
    this.type,
  });

  final String id;
  final String bankName;
  final String fullName;
  final int cardType;
  final String maskedPan;

  final int? amount;

  final String? exp;
  final String? type;

  factory P2PInfoByPhoneNumberRequest.fromJson(Map<String, dynamic> json) =>
      _$P2PInfoByPhoneNumberRequestFromJson(json);

  Map<String, dynamic> toJson() => _$P2PInfoByPhoneNumberRequestToJson(this);
}
