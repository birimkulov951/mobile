import 'package:mobile_ultra/data/api/dto/responses/auth/auth_response.dart';
import 'package:mobile_ultra/domain/auth/auth_entity.dart';

extension AuthResponseExtension on AuthResponse {
  AuthEntity toAuthEntity() => AuthEntity(
        refreshToken: refreshToken,
        accessToken: accessToken,
        userId: userId.toString(),
        tokenType: tokenType,
      );
}
