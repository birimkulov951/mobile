import 'package:json_annotation/json_annotation.dart';

part 'card_beans_response.g.dart';

@JsonSerializable()
class CardBeansResponse {
  const CardBeansResponse({
    this.humo,
    this.uzcard,
  });

  final List<String>? humo;
  final List<String>? uzcard;

  factory CardBeansResponse.fromJson(Map<String, dynamic> json) =>
      _$CardBeansResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CardBeansResponseToJson(this);
}
