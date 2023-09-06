import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'create_bill_response.g.dart';

@JsonSerializable()
class CreateBillResponse {
  CreateBillResponse({
    required this.id,
    required this.merchantId,
    required this.type,
    required this.checkId,
    required this.payId,
    required this.merchantName,
    required this.account,
    required this.amount,
    required this.status,
    required this.statusMessage,
    required this.login,
    required this.tranId,
    required this.ekRequestId,
    required this.requestJson,
    required this.requestTime,
    required this.responseParams,
    required this.responseTime,
  });

  final int id;
  final int merchantId;
  final String type;
  final int checkId;
  final int payId;
  final String merchantName;
  final String account;
  final int amount;
  final int status;
  final String statusMessage;
  final String login;
  final int tranId;
  final int ekRequestId;
  final String requestJson;
  final String requestTime;

  @JsonKey(name: 'responseJson', fromJson: BillResponseParams.fromJsonString)
  final BillResponseParams responseParams;
  final String responseTime;

  factory CreateBillResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateBillResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateBillResponseToJson(this);
}

@JsonSerializable()
class BillResponseParams {
  BillResponseParams({
    required this.status,
    required this.statusText,
    required this.comission,
    required this.success,
    required this.details,
  });

  final int status;
  final String statusText;
  final String comission;
  final bool success;
  final Map<String, dynamic> details;

  static BillResponseParams fromJsonString(String jsonString) =>
      BillResponseParams.fromJson(jsonDecode(jsonString));

  factory BillResponseParams.fromJson(Map<String, dynamic> json) =>
      _$BillResponseParamsFromJson(json);

  Map<String, dynamic> toJson() => _$BillResponseParamsToJson(this);
}
