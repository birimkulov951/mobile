abstract class SettingsRepository {
  bool isBiometricsEnabled();

  Future<void> setBiometricsEnabled({required bool enableBiometrics});
}
