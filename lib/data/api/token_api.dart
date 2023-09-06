import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/api/dto/requests/auth/token_request.dart';
import 'package:mobile_ultra/data/api/dto/responses/auth/token_response.dart';
import 'package:retrofit/retrofit.dart';

part 'token_api.g.dart';

@RestApi()
@singleton
abstract class TokenApi {
  @factoryMethod
  factory TokenApi(@Named("UnauthorizedClient") Dio dio) = _TokenApi;

  @POST('/auth/login')
  Future<TokenResponse> refreshToken(@Body() TokenRequest tokenRequest);
}
