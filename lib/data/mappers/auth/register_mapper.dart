import 'package:mobile_ultra/data/api/dto/requests/auth/register_request.dart';
import 'package:mobile_ultra/domain/auth/register_entity.dart';

extension RegisterEntityExtension on RegisterEntity {
  RegisterRequest toRegisterRequest() => RegisterRequest(
        email: email,
        login: login,
        langKey: langKey,
      );
}
