import 'package:elementary/elementary.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_ultra/domain/remote_config/remote_config_entity.dart';
import 'package:mobile_ultra/repositories/remote_config_repository.dart';

mixin RemoteConfigModelMixin on ElementaryModel {
  @protected
  late final RemoteConfigRepository remoteConfigRepository;

  Future<RemoteConfigEntity> getRemoteConfig() {
    return remoteConfigRepository.getRemoteConfig();
  }
}
