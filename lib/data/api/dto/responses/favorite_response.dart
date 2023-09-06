import 'package:json_annotation/json_annotation.dart';

part 'favorite_response.g.dart';

@JsonSerializable()
class FavoriteResponse {
  FavoriteResponse({
    required this.id,
    required this.bill,
    required this.ord,
    this.billId,
    this.name,
  });

  final int id;

  final String? name;

  final String bill;

  final int? billId;

  @JsonKey(defaultValue: -1)
  final int ord;

  factory FavoriteResponse.fromJson(Map<String, dynamic> json) =>
      _$FavoriteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteResponseToJson(this);

}
