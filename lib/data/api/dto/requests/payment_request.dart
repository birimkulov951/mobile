import 'package:json_annotation/json_annotation.dart';

part 'payment_request.g.dart';

//V2, V3
@JsonSerializable()
class PaymentRequest {
  final int billId;
  final String token;

  //1, 4, 2, 5
  final int cardType;
  // final int filialId;
  // final String agentLogin;
  // final String agentPassword;

  const PaymentRequest({
    required this.billId,
    required this.token,
    required this.cardType,
  });

  Map<String, dynamic> toJson() => _$PaymentRequestToJson(this);
}
