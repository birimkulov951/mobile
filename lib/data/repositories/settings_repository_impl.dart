import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/storages/settings_storage.dart';
import 'package:mobile_ultra/repositories/settings_repository.dart';

@Singleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._settingsStorage);

  final SettingsStorage _settingsStorage;

  @override
  bool isBiometricsEnabled() => _settingsStorage.isBiometricsEnabled;

  @override
  Future<void> setBiometricsEnabled({required bool enableBiometrics}) async {
    await _settingsStorage.setBiometricsEnabled(
        enableBiometrics: enableBiometrics);
  }
}
