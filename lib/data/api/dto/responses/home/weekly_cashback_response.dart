import 'package:json_annotation/json_annotation.dart';
import 'package:mobile_ultra/data/api/dto/responses/home/daily_cashback_response.dart';

part 'weekly_cashback_response.g.dart';

@JsonSerializable()
class WeeklyCashbackResponse {
  const WeeklyCashbackResponse({
    required this.todayCashback,
    required this.maxCashbackInWeek,
    required this.weeklyCashback,
  });

  factory WeeklyCashbackResponse.fromJson(Map<String, dynamic> json) =>
      _$WeeklyCashbackResponseFromJson(json);

  @JsonKey(name: 'maxAmount')
  final double maxCashbackInWeek;
  @JsonKey(name: 'today')
  final DailyCashbackResponse todayCashback;
  @JsonKey(name: 'list')
  final List<DailyCashbackResponse> weeklyCashback;
}
