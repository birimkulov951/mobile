import 'package:json_annotation/json_annotation.dart';

part 'paginable_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class PaginableResponse<T> {
  PaginableResponse({
    required this.totalElements,
    required this.first,
    required this.last,
    required this.totalPages,
    required this.numberOfElements,
    required this.size,
    required this.number,
    required this.content,
    this.sort,
  });

  final int totalElements;
  final bool first;
  final bool last;
  final int totalPages;
  final int numberOfElements;
  final int size;
  final int number;
  final String? sort;

  final List<T> content;

  factory PaginableResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PaginableResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$PaginableResponseToJson(this, toJsonT);
}
