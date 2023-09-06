import 'package:json_annotation/json_annotation.dart';

part 'daily_cashback_response.g.dart';

@JsonSerializable()
class DailyCashbackResponse {
  const DailyCashbackResponse({
    required this.amount,
    required this.date,
  });

  factory DailyCashbackResponse.fromJson(Map<String, dynamic> json) =>
      _$DailyCashbackResponseFromJson(json);

  final double amount;
  @JsonKey(name: 'dates')
  final String date;
}
