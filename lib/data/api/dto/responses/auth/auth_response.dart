import 'package:json_annotation/json_annotation.dart';

part 'auth_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AuthResponse {
  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.tokenType,
  });

  final String accessToken;
  final String refreshToken;
  final int userId;
  final String tokenType;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
