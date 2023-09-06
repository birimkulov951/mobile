import 'package:mobile_ultra/domain/abroad/abroad_transfer_country_entity.dart';
import 'package:mobile_ultra/domain/abroad/abroad_transfer_rate_entity.dart';
import 'package:mobile_ultra/domain/abroad/abroad_transfer_receiver_entity.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_details_screen/route/arguments.dart';

class TransferAbroadConfirmationScreenRouteArguments
    extends TransferDetailsScreenRouteArguments {
  final AttachedCard fromCard;
  final double amount;
  final bool isExchangeRateChanged;

  const TransferAbroadConfirmationScreenRouteArguments({
    required AbroadTransferReceiverEntity receiverEntity,
    required AbroadTransferRateEntity rateEntity,
    required AbroadTransferCountryEntity transferCountryEntity,
    required this.fromCard,
    required this.amount,
    required this.isExchangeRateChanged,
  }) : super(
          receiverEntity: receiverEntity,
          rateEntity: rateEntity,
          transferCountryEntity: transferCountryEntity,
        );
}
