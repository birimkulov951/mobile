import 'package:elementary/elementary.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/net/history/modal/history.dart';
import 'package:mobile_ultra/repositories/fast_payment_repository.dart';
import 'package:mobile_ultra/repositories/merchant_repository.dart';
class FastPaymentScreenModel extends ElementaryModel {
  FastPaymentScreenModel(this._fastPaymentRepository, this._merchantRepository);

  final FastPaymentRepository _fastPaymentRepository;
  final MerchantRepository _merchantRepository;

  MerchantEntity? findMerchant(final int merchantId) {
    return _merchantRepository.findMerchant(merchantId);
  }

  Future<void> setLastExpenditureResetDate(DateTime dateTime) async {
    return await _fastPaymentRepository.setLastExpenditureResetDate(dateTime);
  }

  Future<DateTime?> getLastExpenditureResetDate() async {
    return await _fastPaymentRepository.getLastExpenditureResetDate();
  }

  Future<List<HistoryResponse>> getTransactionHistory(
    String lang,
    int limit,
  ) async {
    try {
      return await _fastPaymentRepository.getTransactionsHistory(lang, limit);
    } on Object catch (_) {
      return [];
    }
  }

  Future<double> getSumOfTodayExpenditure(DateTime startTime) async {
    try {
      return await _fastPaymentRepository.getSumOfTodayExpenditure(startTime);
    } on Object catch (_) {
      return 0.0;
    }
  }
}
