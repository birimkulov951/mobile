import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/api/token_api.dart';
import 'package:mobile_ultra/data/mappers/auth/token_mapper.dart';
import 'package:mobile_ultra/domain/auth/token_entity.dart';
import 'package:mobile_ultra/main.dart' as main;
import 'package:mobile_ultra/net/request_error.dart';
import 'package:mobile_ultra/repositories/token_repository.dart';
import 'package:mobile_ultra/screens/base/mwwm/auth/exceptions/auth_exception.dart';
import 'package:mobile_ultra/utils/const.dart';

@Singleton(as: TokenRepository)
class TokenRepositoryImpl implements TokenRepository {
  TokenRepositoryImpl(this._tokenApi);

  final TokenApi _tokenApi;

  @override
  Future<void> deleteToken() async {
    await main.pref?.setRefreshToken(null);
    await main.pref?.setAccessToken(null);
  }

  @override
  Future<TokenEntity> refreshToken(TokenEntity tokenEntity) async {
    try {
      final request = tokenEntity.toTokenRequest();
      final result = (await _tokenApi.refreshToken(request)).toTokenEntity();
      await saveToken(result);
      return result;
    } on DioError catch (error) {
      throw _getResponseException(error);
    }
  }

  Exception _getResponseException(DioError error) {
    final errorBody = error.response?.data;
    if (errorBody != null && errorBody is Map<String, dynamic>) {
      final requestError = RequestError.fromJson(errorBody);
      if (requestError.detail == Const.ERR_INVALID_TOKEN) {
        return InvalidTokenException();
      }
    }
    return error;
  }

  @override
  Future<void> saveToken(TokenEntity tokenEntity) async {
    await main.pref?.setRefreshToken(tokenEntity.refreshToken);
    await main.pref?.setAccessToken(tokenEntity.accessToken);
    await main.pref?.setTokenType(tokenEntity.tokenType!);
  }

  @override
  TokenEntity getToken() {
    final accessToken = main.pref?.accessToken;
    final tokenType = main.pref?.tokenType;
    var refreshToken = main.pref?.refreshToken;

    // TODO (khamidjon): remove somewhere in future when all users updated
    if (refreshToken?.startsWith('bearer ') == true) {
      refreshToken = refreshToken!.substring(7);
    }

    return TokenEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: tokenType,
    );
  }
}
