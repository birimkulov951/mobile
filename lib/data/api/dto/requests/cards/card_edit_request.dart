import 'package:json_annotation/json_annotation.dart';

part 'card_edit_request.g.dart';

@JsonSerializable()
class CardEditRequest {
  const CardEditRequest({
    required this.name,
    required this.color,
    required this.main,
    required this.order,
    required this.token,
  });

  final String name;
  final int color;
  final int order;
  final bool main;
  final String? token;

  Map<String, dynamic> toJson() => _$CardEditRequestToJson(this);
}
