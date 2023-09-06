import 'package:mobile_ultra/domain/favorite/favorite.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/net/payment/model/bill.dart';
import 'package:mobile_ultra/net/payment/model/payment.dart';

abstract class PaymentRepository {
  Future<void> saveLastPickedCardId({required int? pickedCardId});

  Future<int?> getLastPickedCardId();

  Future<Payment> payFromHumo({
    required int billId,
    required String token,
    required int cardType,
  });

  Future<Payment> payFromUzcard({
    required int billId,
    required String token,
    required int cardType,
  });

  Future<Bill> createBill({
    required MerchantEntity merchant,
    required String account,
    required int amount,
    required Map<String, dynamic> params,
  });

  Future<Payment> makePayment({
    required int billId,
    required String token,
    required int cardType,
  });

  Future<List<FavoriteEntity>> getFavorites();
}
