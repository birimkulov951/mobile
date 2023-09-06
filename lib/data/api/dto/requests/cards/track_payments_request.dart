import 'package:json_annotation/json_annotation.dart';

part 'track_payments_request.g.dart';

@JsonSerializable()
class TrackPaymentsRequest {
  const TrackPaymentsRequest({
    required this.token,
    required this.subscribe,
    required this.account,
  });

  final String token;
  final bool subscribe;
  final String account;

  Map<String, dynamic> toJson() => _$TrackPaymentsRequestToJson(this);
}
