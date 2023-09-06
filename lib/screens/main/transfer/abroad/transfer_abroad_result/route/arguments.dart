import 'package:mobile_ultra/domain/abroad/abroad_transfer_country_entity.dart';
import 'package:mobile_ultra/domain/abroad/abroad_transfer_rate_entity.dart';
import 'package:mobile_ultra/domain/abroad/abroad_transfer_receiver_entity.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/payment/model/payment.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_confirmation/route/arguments.dart';

class TransferAbroadResultScreenArguments
    extends TransferAbroadConfirmationScreenRouteArguments {
  const TransferAbroadResultScreenArguments({
    required AbroadTransferReceiverEntity receiverEntity,
    required AbroadTransferRateEntity rateEntity,
    required AbroadTransferCountryEntity transferCountryEntity,
    required AttachedCard fromCard,
    required double amount,
    required bool isExchangeRateChanged,
    required this.resultStatus,
    this.payment,
  }) : super(
            receiverEntity: receiverEntity,
            rateEntity: rateEntity,
            transferCountryEntity: transferCountryEntity,
            fromCard: fromCard,
            amount: amount,
            isExchangeRateChanged: isExchangeRateChanged);

  final TransferAbroadResultStatus resultStatus;
  final Payment? payment;
}

enum TransferAbroadResultStatus {
  success,
  fail,
  timeOut,
}
