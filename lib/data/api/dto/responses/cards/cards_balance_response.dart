import 'package:json_annotation/json_annotation.dart';
import 'package:mobile_ultra/data/api/dto/responses/cards/card_balance_response.dart';

part 'cards_balance_response.g.dart';

@JsonSerializable()
class CardsBalanceResponse {
  const CardsBalanceResponse({
    required this.cardsBalance,
    required this.totalBalance,
  });

  @JsonKey(name: 'cards')
  final List<CardBalanceResponse> cardsBalance;

  @JsonKey(name: 'total_balance')
  final double totalBalance;

  factory CardsBalanceResponse.fromJson(Map<String, dynamic> json) =>
      _$CardsBalanceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CardsBalanceResponseToJson(this);
}
