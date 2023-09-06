import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/main.dart';

const _biometricsEnablingAskedKey = 'isBiometricsEnablingAsked';
const _isBalanceVisibleKey = 'isBalanceVisible';
const _isAnalyticsSentKey = 'isAnalyticsSent';

@injectable
class HomeStorage {
  const HomeStorage(this._localStorage);

  final Box _localStorage;

  Future<void> setBiometricsEnablingAsked() async {
    await _localStorage.put(_biometricsEnablingAskedKey, true);
  }

  bool get isBiometricsEnablingAsked =>
      _localStorage.get(_biometricsEnablingAskedKey) ?? pref!.isUseFaceID;

  Future<void> setBalanceVisibility({required bool isVisible}) async {
    await _localStorage.put(_isBalanceVisibleKey, isVisible);
  }

  bool get isBalanceVisible =>
      _localStorage.get(_isBalanceVisibleKey) ?? pref!.hideBalance;

  Future<void> setAnalyticsSent() async {
    await _localStorage.put(_isAnalyticsSentKey, true);
  }

  bool get isAnalyticsSent => _localStorage.get(_isAnalyticsSentKey) ?? false;
}
