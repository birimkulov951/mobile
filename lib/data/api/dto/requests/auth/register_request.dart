import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequest {
  RegisterRequest({
    required this.login,
    required this.email,
    required this.langKey,
  });

  final String login;
  final String email;
  final String langKey;

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
