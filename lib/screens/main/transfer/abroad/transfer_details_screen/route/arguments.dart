import 'package:mobile_ultra/domain/abroad/abroad_transfer_country_entity.dart';
import 'package:mobile_ultra/domain/abroad/abroad_transfer_receiver_entity.dart';
import 'package:mobile_ultra/domain/abroad/abroad_transfer_rate_entity.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_receiver_search_screen/route/arguments.dart';

class TransferDetailsScreenRouteArguments
    extends TransferAbroadReceiverSearchScreenRouteArguments {
  const TransferDetailsScreenRouteArguments({
    required this.receiverEntity,
    required this.rateEntity,
    required AbroadTransferCountryEntity transferCountryEntity,
  }) : super(transferCountryEntity);

  final AbroadTransferReceiverEntity receiverEntity;
  final AbroadTransferRateEntity rateEntity;
}
