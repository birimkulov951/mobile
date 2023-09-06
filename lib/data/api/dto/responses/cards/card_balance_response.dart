import 'package:json_annotation/json_annotation.dart';

part 'card_balance_response.g.dart';

@JsonSerializable()
class CardBalanceResponse {
  const CardBalanceResponse({
    required this.token,
    required this.balance,
    required this.status,
    required this.sms,
  });

  final String token;
  final double balance;
  final String status;
  final bool sms;

  factory CardBalanceResponse.fromJson(Map<String, dynamic> json) =>
      _$CardBalanceResponseFromJson(json);
}
