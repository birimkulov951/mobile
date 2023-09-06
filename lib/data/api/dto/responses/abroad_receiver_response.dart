import 'package:json_annotation/json_annotation.dart';

part 'abroad_receiver_response.g.dart';

@JsonSerializable()
class AbroadReceiverResponse {
  const AbroadReceiverResponse({
    required this.pan,
    required this.maskedPan,
    this.bankName,
    this.logoUrl,
  });

  final String pan;
  final String maskedPan;
  final String? bankName;
  final String? logoUrl;

  factory AbroadReceiverResponse.fromJson(Map<String, dynamic> json) =>
      _$AbroadReceiverResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AbroadReceiverResponseToJson(this);
}
