import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/storages/charles_storage.dart';
import 'package:mobile_ultra/repositories/charles_repository.dart';

@Singleton(as: CharlesRepository)
class CharlesRepositoryImpl implements CharlesRepository {
  const CharlesRepositoryImpl(this._charlesStorage);

  final CharlesStorage _charlesStorage;

  @override
  bool isCharlesProxyEnabled() {
    return _charlesStorage.isCharlesProxyEnabled;
  }

  @override
  Future<void> setCharlesProxyEnabled({required bool isEnabled}) async {
    await _charlesStorage.setCharlesProxyEnabled(isEnabled: isEnabled);
  }

  @override
  String? charlesIpAddress() {
    return _charlesStorage.charlesIpAddress;
  }

  @override
  Future<void> setCharlesIpAddress({required String ipAddress}) async {
    await _charlesStorage.setCharlesIpAddress(ipAddress: ipAddress);
  }
}
