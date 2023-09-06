import 'package:elementary/elementary.dart';
import 'package:mobile_ultra/domain/remote_config/remote_config_entity.dart';
import 'package:mobile_ultra/screens/base/mwwm/remote_config/remote_config_model.dart';

mixin IRemoteConfigWidgetModelMixin on IWidgetModel {
  ListenableState<EntityState<RemoteConfigEntity>> get remoteConfig;
}

mixin RemoteConfigWidgetModelMixin<W extends ElementaryWidget<IWidgetModel>,
        M extends RemoteConfigModelMixin> on WidgetModel<W, M>
    implements IRemoteConfigWidgetModelMixin {
  final _remoteConfig = EntityStateNotifier<RemoteConfigEntity>();

  @override
  ListenableState<EntityState<RemoteConfigEntity>> get remoteConfig =>
      _remoteConfig;

  Future<void> fetchRemoteConfig() async {
    try {
      _remoteConfig.loading(_remoteConfig.value?.data);
      final remoteConfigModel = await model.getRemoteConfig();
      _remoteConfig.content(remoteConfigModel);
    } on Exception catch (error) {
      _remoteConfig.error(error, _remoteConfig.value?.data);
    }
  }
}
