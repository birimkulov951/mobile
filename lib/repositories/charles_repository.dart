abstract class CharlesRepository {
  bool isCharlesProxyEnabled();

  Future<void> setCharlesProxyEnabled({required bool isEnabled});

  String? charlesIpAddress();

  Future<void> setCharlesIpAddress({required String ipAddress});
}
