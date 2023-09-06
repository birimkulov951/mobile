import 'package:json_annotation/json_annotation.dart';

part 'cards_by_phone_number_response.g.dart';

@JsonSerializable()
class CardsByPhoneNumberResponse {
  const CardsByPhoneNumberResponse({
    required this.data,
    required this.success,
  });

  final BankType data;
  final bool success;

  factory CardsByPhoneNumberResponse.fromJson(Map<String, dynamic> json) =>
      _$CardsByPhoneNumberResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CardsByPhoneNumberResponseToJson(this);
}

@JsonSerializable()
class BankType {
  const BankType({
    required this.paynet,
    required this.other,
  });

  final List<BankCard> paynet;
  final List<BankCard> other;

  factory BankType.fromJson(Map<String, dynamic> json) =>
      _$BankTypeFromJson(json);

  Map<String, dynamic> toJson() => _$BankTypeToJson(this);
}

@JsonSerializable()
class BankCard {
  const BankCard({
    required this.id,
    required this.maskedPan,
    required this.fullName,
    required this.expiry,
    required this.bank,
    required this.cardType,
  });

  final String id;
  final String maskedPan;
  final String fullName;
  final String? expiry;
  final Bank bank;
  final int cardType;

  factory BankCard.fromJson(Map<String, dynamic> json) =>
      _$BankCardFromJson(json);

  Map<String, dynamic> toJson() => _$BankCardToJson(this);
}

@JsonSerializable()
class Bank {
  const Bank({
    required this.bankName,
    required this.logo,
  });

  final String bankName;
  final String logo;

  factory Bank.fromJson(Map<String, dynamic> json) => _$BankFromJson(json);

  Map<String, dynamic> toJson() => _$BankToJson(this);
}
