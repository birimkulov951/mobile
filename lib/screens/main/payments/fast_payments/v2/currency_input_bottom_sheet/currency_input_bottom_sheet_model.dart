import 'package:elementary/elementary.dart';
import 'package:mobile_ultra/domain/payment/payment_result.dart';
import 'package:mobile_ultra/net/card/model/card.dart' as UCard;
import 'package:mobile_ultra/repositories/merchant_repository.dart';
import 'package:mobile_ultra/repositories/payment_repository.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/currency_input_bottom_sheet/exceptions/could_not_make_payment_exception.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_confirmation/exceptions/otp_exception.dart';

const _pynetCellularMerchantId = 7449;

class CurrencyInputBottomSheetModel extends ElementaryModel {
  CurrencyInputBottomSheetModel({
    required this.merchantRepository,
    required this.paymentRepository,
  });

  final MerchantRepository merchantRepository;
  final PaymentRepository paymentRepository;

  Future<PaymentResult> topUpPhoneNumber({
    required final int amount,
    required final String phoneNumber,
    required final UCard.AttachedCard card,
  }) async {
    try {
      final merchant =
          merchantRepository.findMerchant(_pynetCellularMerchantId);
      if (merchant == null) {
        return PaymentResult.failed(CouldNotMakePaymentException());
      }

      final bill = await paymentRepository.createBill(
        merchant: merchant,
        account: phoneNumber,
        amount: amount,
        params: {
          "clientid": phoneNumber,
          "amount": amount,
        },
      );
      return await this.payBill(
        billId: bill.id!,
        token: card.token!,
        cardType: card.type!,
      );
    } on Object catch (error) {
      return PaymentResult.failed(error);
    }
  }

  Future<PaymentResult> payBill({
    required int billId,
    required String token,
    required int cardType,
  }) async {
    try {
      final payment = await paymentRepository.makePayment(
        billId: billId,
        token: token,
        cardType: cardType,
      );
      return PaymentResult.success(payment);
    } on OtpException catch (error) {
      return PaymentResult.otp(error);
    } on Object catch (error) {
      return PaymentResult.failed(error);
    }
  }
}
