import 'package:json_annotation/json_annotation.dart';

part 'create_bill_request.g.dart';

//Act2DTO
@JsonSerializable()
class CreateBillRequest {
  CreateBillRequest({
    required this.account,
    required this.amount,
    required this.merchantId,
    required this.merchantName,
    required this.checkId,
    required this.payId,
    required this.params,
  });

  final String account;
  final int amount;
  final int merchantId;
  final String merchantName;
  final int? checkId;
  final int? payId;
  final Map<String, dynamic> params;

  factory CreateBillRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateBillRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateBillRequestToJson(this);
}
