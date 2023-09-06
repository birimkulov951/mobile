import 'package:mobile_ultra/net/history/modal/history.dart';

abstract class FastPaymentRepository {
  Future<List<HistoryResponse>> getTransactionsHistory(String lang, int limit);

  Future<void> setLastExpenditureResetDate(DateTime dateTime);

  Future<DateTime?> getLastExpenditureResetDate();

  Future<double> getSumOfTodayExpenditure(DateTime startDate);
}
