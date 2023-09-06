import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/api/auth_api.dart';
import 'package:mobile_ultra/data/api/dto/requests/auth/auth_request.dart';
import 'package:mobile_ultra/data/mappers/auth/auth_mapper.dart';
import 'package:mobile_ultra/data/mappers/auth/register_mapper.dart';
import 'package:mobile_ultra/domain/auth/auth_entity.dart';
import 'package:mobile_ultra/domain/auth/register_entity.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/request_error.dart';
import 'package:mobile_ultra/repositories/auth_repository.dart';
import 'package:mobile_ultra/screens/base/mwwm/auth/exceptions/auth_exception.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:package_info_plus/package_info_plus.dart';

@Singleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._authApi);

  final AuthApi _authApi;

  @override
  Future<bool> checkIfUserExists(String phoneNumber) async {
    return (await _authApi.checkIfUserExists(phoneNumber)).success;
  }

  @override
  void savePhoneNumber(String phoneNumber) {
    pref!.setViewLogin(phoneNumber);
  }

  @override
  String get phoneNumber => pref!.getViewLogin;

  @override
  Future<void> register(RegisterEntity registerEntity) async {
    await _authApi.register(registerEntity.toRegisterRequest());
  }

  @override
  Future<void> fetchLoginOtp({
    required String phoneNumber,
    required AuthType authType,
  }) async {
    try {
      final authRequest = await _constructAuthRequest(
        phoneNumber: phoneNumber,
        authType: authType,
      );
      await _authApi.fetchLoginOtp(authRequest);
    } on DioError catch (error) {
      throw _getResponseException(error);
    }
  }

  @override
  Future<AuthEntity> loginByOtp({
    required String phoneNumber,
    required String otpCode,
    required AuthType authType,
  }) async {
    final authRequest = await _constructAuthRequest(
      phoneNumber: phoneNumber,
      otpCode: otpCode,
      authType: authType,
    );
    try {
      return (await _authApi.login(authRequest)).toAuthEntity();
    } on DioError catch (error) {
      throw _getResponseException(error);
    }
  }

  Exception _getResponseException(DioError error) {
    final errorBody = error.response?.data;
    if (errorBody != null && errorBody is Map<String, dynamic>) {
      final requestError = RequestError.fromJson(errorBody);
      if (requestError.detail == Const.ERR_BAD_CREDENTIALS) {
        return BadCredentialsException();
      } else if (requestError.detail == Const.ERR_ACTIVATION_CODE_SENT) {
        return ActivationCodeSentException();
      } else if (requestError.detail == Const.ERR_INVALID_TOKEN) {
        return InvalidTokenException();
      } else if (requestError.detail == Const.ERR_ACCESS_DENIED) {
        return AccessDeniedException();
      }
    }
    return error;
  }

  Future<AuthRequest> _constructAuthRequest({
    required String phoneNumber,
    required AuthType authType,
    String? otpCode,
    String? password,
  }) async {
    final deviceInfo = DeviceInfoPlugin();
    late final String deviceName;
    late final String deviceId;

    if (Platform.isAndroid) {
      const androidIdPlugin = AndroidId();
      final androidInfo = await deviceInfo.androidInfo;
      deviceName =
      ' Brand :${androidInfo.brand};  Model:${androidInfo
          .model};, android: ${androidInfo.version
          .release}; Display: ${androidInfo.display}; sdk: ${androidInfo.version
          .sdkInt};';

      deviceId = (await androidIdPlugin.getId())?.toLowerCase() ?? '';
    } else {
      final iosInfo = await deviceInfo.iosInfo;
      deviceName =
      'model : ${iosInfo.model} ${iosInfo.name};  - System Name : ${iosInfo
          .systemName};  System Version : ${iosInfo
          .systemVersion}  Identifier : ${iosInfo
          .identifierForVendor};  UtsName: ${iosInfo
          .utsname}; LocalizedModel: ${iosInfo
          .localizedModel}; -  PhysicalDevice: ${iosInfo.isPhysicalDevice};';
      deviceId = iosInfo.identifierForVendor?.toLowerCase() ?? '';
    }

    return AuthRequest(
      username: phoneNumber,
      password: password,
      deviceId: deviceId.toLowerCase(),
      deviceName: deviceName,
      version: (await PackageInfo.fromPlatform()).version,
      otpCode: otpCode,
      fcmToken: await getFcmToken(),
      language: pref?.prefix,
      platform: Platform.isAndroid ? 'android' : 'iphone',
      authType: authType.value,
    );
  }

  Future<String?> getFcmToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } on Object catch (_) {
      return null;
    }
  }
}
