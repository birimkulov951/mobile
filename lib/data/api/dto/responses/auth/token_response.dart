import 'package:json_annotation/json_annotation.dart';

part 'token_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TokenResponse {
  TokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
  });

  final String accessToken;
  final String refreshToken;
  final String tokenType;

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseFromJson(json);
}
