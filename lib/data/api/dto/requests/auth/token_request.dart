import 'package:json_annotation/json_annotation.dart';

part 'token_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TokenRequest {
  TokenRequest({
    required this.refreshToken,
    required this.grantType,
  });

  Map<String, dynamic> toJson() => _$TokenRequestToJson(this);

  final String? refreshToken;
  final String grantType;
}
