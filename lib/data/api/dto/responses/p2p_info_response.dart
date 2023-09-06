import 'package:json_annotation/json_annotation.dart';

part 'p2p_info_response.g.dart';

@JsonSerializable()
class P2PInfoResponse {
  P2PInfoResponse({
    required this.pan,
    required this.fio,
    required this.commissionPercent,
    required this.limitIn,
    required this.limitOut,
    this.exp,
    this.receiverToken,
    this.receiverBankName,
    this.userId,
    this.commissionAmount,
    this.commissionPrice,
    this.max,
    this.min,
    this.senderCardType,
    this.receiverCardType,
    this.amount,
    this.type,
  });

  final String pan;
  final String fio;

  final double commissionPercent;
  final int limitIn;
  final int limitOut;
  final String? exp;

  final String? receiverToken;
  final String? receiverBankName;
  final String? userId;
  final double? commissionAmount;
  final double? commissionPrice;

  final int? max;
  final int? min;

  final int? senderCardType;
  final int? receiverCardType;

  final int? amount;
  final String? type;

  factory P2PInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$P2PInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$P2PInfoResponseToJson(this);
}

@JsonSerializable()
class P2PInfoByLoginResponse extends P2PInfoResponse {
  P2PInfoByLoginResponse({
    required super.pan,
    required super.fio,
    required super.commissionPercent,
    required super.limitIn,
    required super.limitOut,
    super.exp,
    super.receiverToken,
    super.receiverBankName,
    super.userId,
    super.commissionAmount,
    super.commissionPrice,
    super.max,
    super.min,
    super.senderCardType,
    super.receiverCardType,
    super.amount,
    super.type,
    this.hasPynetCard,
    this.hasOtherCard,
    this.statusCode,
    this.statusMessage,
    this.historyId,
  });

  final bool? hasPynetCard;
  final bool? hasOtherCard;
  final int? statusCode;
  final String? statusMessage;
  final int? historyId;

  factory P2PInfoByLoginResponse.fromJson(Map<String, dynamic> json) =>
      _$P2PInfoByLoginResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$P2PInfoByLoginResponseToJson(this);
}
