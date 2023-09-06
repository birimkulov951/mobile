import 'package:elementary/elementary.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_ultra/domain/common/p2p_check_type.dart';
import 'package:mobile_ultra/domain/transfer/transfer_result.dart';
import 'package:mobile_ultra/repositories/transfer_repository.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_confirmation/exceptions/otp_exception.dart';

mixin TransferMixin on ElementaryModel {
  @protected
  late final TransferRepository transferRepository;

  Future<TransferResult> makeP2PTransfer({
    required String senderCardToken,
    required String receiverCardToken,
    required String fio,
    required String? exp,
    required int senderCardType,
    required int receiverCardType,
    required int amount,
    required P2PCheckType receiverMethodType,
    required String? receiverBankName,
  }) async {
    try {
      final p2pPaymentEntity = await transferRepository.createP2PTransfer(
        receiverCardToken: receiverCardToken,
        senderCardToken: senderCardToken,
        fio: fio,
        exp: exp,
        senderCardType: senderCardType,
        receiverCardType: receiverCardType,
        amount: amount,
        receiverMethodType: receiverMethodType,
        receiverBankName: receiverBankName,
      );
      return TransferResult.success(p2pPaymentEntity);
    } on OtpException catch (error) {
      return TransferResult.otp(error);
    } on Object catch (error) {
      return TransferResult.failed(error);
    }
  }
}
