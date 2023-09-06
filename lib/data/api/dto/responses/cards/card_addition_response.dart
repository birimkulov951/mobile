import 'package:json_annotation/json_annotation.dart';

part 'card_addition_response.g.dart';

@JsonSerializable()
class CardAdditionResponse {
  const CardAdditionResponse({
    this.id,
    this.token,
    this.name,
    this.maskedPan,
    this.status,
    this.phone,
    this.balance,
    this.sms,
    this.bankId,
    this.login,
    this.main,
    this.color,
    this.expireDate,
    this.createdDate,
    this.activated,
    this.order,
    this.activatedDate,
    this.bankName,
    this.type,
    this.p2pEnabled,
    this.subscribed,
    this.subscribeLastDate,
    this.entryCount,
    this.valid,
    this.maskedPhone,
  });

  final int? id;
  final String? token;
  final String? name;
  final String? maskedPan;
  final String? status;
  final String? phone;
  final double? balance;
  final bool? sms;
  final String? bankId;
  final String? login;
  final bool? main;
  final int? color;
  final String? expireDate;
  final String? createdDate;
  final String? activated;
  final int? order;
  final String? activatedDate;
  final String? bankName;
  final int? type;
  final bool? p2pEnabled;
  final bool? subscribed;
  final String? subscribeLastDate;
  final int? entryCount;
  final bool? valid;
  final String? maskedPhone;

  factory CardAdditionResponse.fromJson(Map<String, dynamic> json) =>
      _$CardAdditionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CardAdditionResponseToJson(this);
}
