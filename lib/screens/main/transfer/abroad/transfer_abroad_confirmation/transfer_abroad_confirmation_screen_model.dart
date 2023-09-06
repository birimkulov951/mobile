import 'package:elementary/elementary.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_ultra/domain/payment/payment_result.dart';
import 'package:mobile_ultra/net/payment/model/payment.dart';
import 'package:mobile_ultra/repositories/payment_repository.dart';
import 'package:mobile_ultra/utils/const.dart';

import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_confirmation/exceptions/otp_exception.dart';

class TransferAbroadConfirmationScreenModel extends ElementaryModel {
  TransferAbroadConfirmationScreenModel(
    this._transferAbroadConfirmationRepository,
  );

  @protected
  final PaymentRepository _transferAbroadConfirmationRepository;

  Future<PaymentResult> makeTransfer({
    required int billId,
    required String token,
    required int cardType,
  }) async {
    Payment payment;
    try {
      if (cardType == Const.HUMO) {
        payment = await _makeTransferFromHumo(
          billId: billId,
          token: token,
          cardType: cardType,
        );
      } else {
        payment = await _makeTransferFromUzcard(
          billId: billId,
          token: token,
          cardType: cardType,
        );
      }
    } on OtpException catch (error) {
      return PaymentResult.otp(error);
    } on Object catch (error) {
      return PaymentResult.failed(error);
    }
    return PaymentResult.success(payment);
  }

  Future<Payment> _makeTransferFromUzcard({
    required int billId,
    required String token,
    required int cardType,
  }) async {
    return await _transferAbroadConfirmationRepository.payFromUzcard(
      billId: billId,
      token: token,
      cardType: cardType,
    );
  }

  Future<Payment> _makeTransferFromHumo({
    required int billId,
    required String token,
    required int cardType,
  }) async {
    return await _transferAbroadConfirmationRepository.payFromHumo(
      billId: billId,
      token: token,
      cardType: cardType,
    );
  }
}
