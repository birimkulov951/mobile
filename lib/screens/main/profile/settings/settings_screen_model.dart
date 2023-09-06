import 'package:elementary/elementary.dart';
import 'package:mobile_ultra/repositories/merchant_repository.dart';
import 'package:mobile_ultra/repositories/settings_repository.dart';

class SettingsScreenModel extends ElementaryModel {
  SettingsScreenModel(this._settingsRepository, this._merchantRepository);

  final SettingsRepository _settingsRepository;
  final MerchantRepository _merchantRepository;

  Future<void> clearAllPaymentData() async {
    await _merchantRepository.clearAllPaymentData();
  }

  void changeBiometricUseStatus() {
    final isBiometricsEnabled = _settingsRepository.isBiometricsEnabled();
    _settingsRepository.setBiometricsEnabled(
        enableBiometrics: !isBiometricsEnabled);
  }

  bool isBiometricsEnabled() => _settingsRepository.isBiometricsEnabled();
}
