import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ultra/data/api/history_api.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/history/modal/history.dart';
import 'package:mobile_ultra/repositories/fast_payment_repository.dart';

@Singleton(as: FastPaymentRepository)
class FastPaymentRepositoryImpl implements FastPaymentRepository {
  final HistoryApi _historyApi;

  FastPaymentRepositoryImpl(this._historyApi);

  @override
  Future<DateTime?> getLastExpenditureResetDate() async {
    return await pref?.getLastExpenditureResetDate;
  }

  @override
  Future<List<HistoryResponse>> getTransactionsHistory(
    String lang,
    int limit,
  ) async {
    return await _historyApi.getTransactionsHistory(lang, limit);
  }

  @override
  Future<void> setLastExpenditureResetDate(DateTime dateTime) async {
    await pref?.setLastExpenditureResetDate(dateTime);
  }

  @override
  Future<double> getSumOfTodayExpenditure(DateTime startDate) async {
    final formattedTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(startDate);
    final response = await _historyApi.getSumOfTodayExpenditure(formattedTime);
    return response.toDouble();
  }
}
