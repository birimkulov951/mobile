import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/main.dart';

@injectable
class SettingsStorage {
  const SettingsStorage(this._localStorage);

  final Box _localStorage;

  bool get isBiometricsEnabled =>
      _localStorage.get('isBiometricsEnabled') ?? pref!.isUseFaceID;

  Future<void> setBiometricsEnabled({required bool enableBiometrics}) async {
    await _localStorage.put('isBiometricsEnabled', enableBiometrics);
    await pref!.setUseFaceID(enableBiometrics);
  }
}
