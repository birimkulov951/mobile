import 'package:mobile_ultra/domain/home/monthly_cashback_entity.dart';
import 'package:mobile_ultra/domain/home/weekly_cashback_entity.dart';
import 'package:mobile_ultra/net/payment/model/pynetid.dart';

abstract class HomeRepository {
  Future<List<PynetId>> getMyAccounts();

  bool isBiometricsEnablingAsked();

  String get phoneNumber;

  Future<void> setBiometricsEnablingAsked();

  bool isBalanceVisible();

  Future<void> setBalanceVisibility({required bool isVisible});

  Future<MonthlyCashbackEntity> getMonthlyCashback();

  Future<WeeklyCashbackEntity> getWeeklyCashback();

  Future<void> setAnalyticsSent();

  bool isAnalyticsSent();
}
