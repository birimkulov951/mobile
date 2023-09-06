import 'package:json_annotation/json_annotation.dart';

part 'track_payments_response.g.dart';

@JsonSerializable()
class TrackPaymentsResponse {
  const TrackPaymentsResponse({
    required this.success,
    required this.subscribedDate,
  });

  final bool success;
  @JsonKey(name: 'lastSubscribeDateTimestamp')
  final String? subscribedDate;

  factory TrackPaymentsResponse.fromJson(Map<String, dynamic> json) =>
      _$TrackPaymentsResponseFromJson(json);
}
