import 'package:json_annotation/json_annotation.dart';

part 'auth_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AuthRequest {
  AuthRequest({
    required this.username,
    required this.password,
    required this.deviceId,
    required this.deviceName,
    required this.version,
    required this.otpCode,
    required this.fcmToken,
    required this.language,
    required this.platform,
    required this.authType,
  });

  final String username;
  final String? password;
  final String? deviceId;
  final String? deviceName;
  final String? version;
  @JsonKey(name: 'code')
  final String? otpCode;
  @JsonKey(name: 'fcm')
  final String? fcmToken;
  @JsonKey(name: 'lang')
  final String? language;
  final String? platform;
  final String authType;

  Map<String, dynamic> toJson() => _$AuthRequestToJson(this);
}
