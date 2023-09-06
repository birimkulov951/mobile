import 'package:json_annotation/json_annotation.dart';

part 'card_addition_request.g.dart';

@JsonSerializable()
class CardAdditionRequest {
  const CardAdditionRequest({
    required this.color,
    required this.expiry,
    required this.main,
    required this.pan,
    required this.name,
    required this.order,
    required this.type,
    this.token,
  });

  final int color;
  final String expiry;
  final bool main;
  final String pan;
  final String name;
  final int order;
  final int type;
  final String? token;

  Map<String, dynamic> toJson() => _$CardAdditionRequestToJson(this);
}
