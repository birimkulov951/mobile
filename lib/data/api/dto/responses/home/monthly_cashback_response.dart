import 'package:json_annotation/json_annotation.dart';

part 'monthly_cashback_response.g.dart';

@JsonSerializable()
class MonthlyCashbackResponse {
  const MonthlyCashbackResponse({
    required this.success,
    required this.data,
  });

  factory MonthlyCashbackResponse.fromJson(Map<String, dynamic> json) =>
      _$MonthlyCashbackResponseFromJson(json);

  final bool success;
  final MonthlyCashbackDataResponse data;
}

@JsonSerializable()
class MonthlyCashbackDataResponse {
  const MonthlyCashbackDataResponse({
    required this.amount,
    required this.currentMonth,
  });

  factory MonthlyCashbackDataResponse.fromJson(Map<String, dynamic> json) =>
      _$MonthlyCashbackDataResponseFromJson(json);

  final int amount;
  final int currentMonth;
}
