import 'package:json_annotation/json_annotation.dart';

part 'transfer_commission_response.g.dart';

@JsonSerializable()
class TransferCommissionResponse {
  const TransferCommissionResponse(
    this.sender,
    this.receiver,
    this.commission,
  );

  final int sender;
  final int receiver;
  final double commission;

  factory TransferCommissionResponse.fromJson(Map<String, dynamic> json) =>
      _$TransferCommissionResponseFromJson(json);
}
