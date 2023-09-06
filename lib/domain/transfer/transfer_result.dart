import 'package:mobile_ultra/domain/transfer/p2p_payment_entity.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_confirmation/exceptions/otp_exception.dart';

class TransferResult {
  TransferResult._({
    required this.status,
    this.p2pResult,
    this.error,
  });

  factory TransferResult.success(P2PResultEntity p2pPaymentEntity) {
    return TransferResult._(
      status: TransferResultStatus.success,
      p2pResult: p2pPaymentEntity,
    );
  }


  factory TransferResult.otp(OtpException error) {
    return TransferResult._(status: TransferResultStatus.otp, error: error);
  }

  factory TransferResult.failed(Object error) {
    return TransferResult._(status: TransferResultStatus.failed, error: error);
  }

  final Object? error;
  final P2PResultEntity? p2pResult;
  final TransferResultStatus status;
}

enum TransferResultStatus { success, otp, failed }
