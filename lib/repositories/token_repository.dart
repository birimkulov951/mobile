import 'package:mobile_ultra/domain/auth/token_entity.dart';

abstract class TokenRepository {
  TokenEntity getToken();

  Future<TokenEntity> refreshToken(TokenEntity tokenEntity);

  Future<void> saveToken(TokenEntity tokenEntity);

  Future<void> deleteToken();
}
