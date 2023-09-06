import 'package:mobile_ultra/domain/auth/auth_entity.dart';
import 'package:mobile_ultra/domain/auth/register_entity.dart';

abstract class AuthRepository {
  Future<bool> checkIfUserExists(String phoneNumber);

  void savePhoneNumber(String phoneNumber);

  String get phoneNumber;

  Future<void> register(RegisterEntity registerEntity);

  Future<void> fetchLoginOtp({
    required String phoneNumber,
    required AuthType authType,
  });

  Future<AuthEntity> loginByOtp({
    required String phoneNumber,
    required String otpCode,
    required AuthType authType,
  });
}
