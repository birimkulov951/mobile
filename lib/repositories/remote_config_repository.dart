import 'package:mobile_ultra/domain/remote_config/remote_config_entity.dart';

abstract class RemoteConfigRepository {
  Future<RemoteConfigEntity> getRemoteConfig();
}
