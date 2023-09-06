import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/api/dto/requests/auth/auth_request.dart';
import 'package:mobile_ultra/data/api/dto/requests/auth/register_request.dart';
import 'package:mobile_ultra/data/api/dto/responses/auth/auth_response.dart';
import 'package:mobile_ultra/data/api/dto/responses/common_response.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api.g.dart';

@RestApi()
@singleton
abstract class AuthApi {
  @factoryMethod
  factory AuthApi(@Named("UnauthorizedClient") Dio dio) = _AuthApi;

  @GET('/uaa/api/m/phone/{phoneNumber}')
  Future<CommonResponse> checkIfUserExists(@Path() String phoneNumber);

  @POST('/uaa/api/v2/register')
  Future<void> register(@Body() RegisterRequest registerRequest);

  @POST('/auth/login')
  Future<void> fetchLoginOtp(@Body() AuthRequest authRequest);

  @POST('/auth/login')
  Future<AuthResponse> login(@Body() AuthRequest authRequest);
}
