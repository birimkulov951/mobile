import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

const _isCharlesProxyEnabled = 'isCharlesProxyEnabled';
const _charlesIpAddress = 'charlesIpAddress';

@injectable
class CharlesStorage {
  const CharlesStorage(this._localStorage);

  final Box _localStorage;

  bool get isCharlesProxyEnabled =>
      _localStorage.get(_isCharlesProxyEnabled) ?? false;

  Future<void> setCharlesProxyEnabled({required bool isEnabled}) async =>
      await _localStorage.put(_isCharlesProxyEnabled, isEnabled);

  String? get charlesIpAddress => _localStorage.get(_charlesIpAddress);

  Future<void> setCharlesIpAddress({required String ipAddress}) async =>
      await _localStorage.put(_charlesIpAddress, ipAddress);
}
