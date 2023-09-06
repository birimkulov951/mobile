import 'package:mobile_ultra/net/payment/model/payment.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_confirmation/exceptions/otp_exception.dart';

class PaymentResult {
  PaymentResult._({
    required this.status,
    this.payment,
    this.error,
  });

  factory PaymentResult.success(Payment payment) {
    return PaymentResult._(
        status: PaymentResultStatus.success, payment: payment);
  }

  factory PaymentResult.otp(OtpException error) {
    return PaymentResult._(status: PaymentResultStatus.otp, error: error);
  }

  factory PaymentResult.failed(Object error) {
    return PaymentResult._(status: PaymentResultStatus.failed, error: error);
  }

  final Payment? payment;
  final Object? error;
  final PaymentResultStatus status;
}

enum PaymentResultStatus { success, otp, failed }
