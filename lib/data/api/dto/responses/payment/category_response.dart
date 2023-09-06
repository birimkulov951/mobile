import 'package:json_annotation/json_annotation.dart';

part 'category_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CategoryResponse {
  CategoryResponse({
    required this.id,
    required this.nameRu,
    required this.nameUz,
    required this.nameEn,
    required this.displayOrder,
  });

  factory CategoryResponse.fromJson(final Map<String, dynamic> json) =>
      _$CategoryResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryResponseToJson(this);

  final int id;
  final String nameRu;
  final String nameUz;
  final String nameEn;
  final int displayOrder;
}
