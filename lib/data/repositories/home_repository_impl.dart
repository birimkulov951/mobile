import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/api/home_api.dart';
import 'package:mobile_ultra/data/mappers/home/monthly_cashback_mapper.dart';
import 'package:mobile_ultra/data/mappers/home/weekly_cashback_mapper.dart';
import 'package:mobile_ultra/data/storages/home_storage.dart';
import 'package:mobile_ultra/domain/home/monthly_cashback_entity.dart';
import 'package:mobile_ultra/domain/home/weekly_cashback_entity.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/payment/model/paynetid.dart';
import 'package:mobile_ultra/repositories/home_repository.dart';

@Singleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(
    this._homeApi,
    this._homeStorage,
  );

  final HomeApi _homeApi;
  final HomeStorage _homeStorage;

  @override
  Future<List<PaynetId>> getMyAccounts() async {
    return await _homeApi.getMyAccounts();
  }

  @override
  bool isBiometricsEnablingAsked() => _homeStorage.isBiometricsEnablingAsked;

  @override
  String get phoneNumber => pref!.getViewLogin;

  @override
  Future<void> setBiometricsEnablingAsked() async {
    await _homeStorage.setBiometricsEnablingAsked();
  }

  @override
  bool isBalanceVisible() => _homeStorage.isBalanceVisible;

  @override
  Future<void> setBalanceVisibility({required bool isVisible}) async {
    await _homeStorage.setBalanceVisibility(isVisible: isVisible);
  }

  @override
  Future<MonthlyCashbackEntity> getMonthlyCashback() async {
    return (await _homeApi.getMonthlyCashback()).toEntity();
  }

  @override
  Future<WeeklyCashbackEntity> getWeeklyCashback() async {
    return (await _homeApi.getWeeklyCashback()).toEntity();
  }

  @override
  bool isAnalyticsSent() {
    return _homeStorage.isAnalyticsSent;
  }

  @override
  Future<void> setAnalyticsSent() async {
    await _homeStorage.setAnalyticsSent();
  }
}
