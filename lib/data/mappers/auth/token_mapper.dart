import 'package:mobile_ultra/data/api/dto/requests/auth/token_request.dart';
import 'package:mobile_ultra/data/api/dto/responses/auth/token_response.dart';
import 'package:mobile_ultra/domain/auth/token_entity.dart';

extension TokenResponseExtension on TokenResponse {
  TokenEntity toTokenEntity() => TokenEntity(
        accessToken: accessToken,
        refreshToken: refreshToken,
        tokenType: tokenType,
      );
}

extension TokenEntityExtension on TokenEntity {
  TokenRequest toTokenRequest() => TokenRequest(
        refreshToken: refreshToken,
        grantType: "refresh_token",
      );
}
