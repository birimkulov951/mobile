import 'package:equatable/equatable.dart';

class AuthEntity with EquatableMixin {
  AuthEntity({
    required this.refreshToken,
    required this.accessToken,
    required this.userId,
    required this.tokenType,
  });

  final String accessToken;
  final String refreshToken;
  final String userId;
  final String tokenType;

  @override
  List<Object> get props => [
        refreshToken,
        accessToken,
        userId,
        tokenType,
      ];
}

enum AuthType {
  password('password'),
  otp('otp'),
  otpCreate('otp_create');

  final String value;

  const AuthType(this.value);
}
