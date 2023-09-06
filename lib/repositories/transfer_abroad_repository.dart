import 'package:mobile_ultra/domain/abroad/abroad_transfer_receiver_entity.dart';
import 'package:mobile_ultra/domain/abroad/abroad_transfer_rate_entity.dart';

abstract class TransferAbroadRepository {
  Future<List<AbroadTransferReceiverEntity>> getLastReceivers();

  Future<AbroadTransferReceiverEntity> getReceiverByPan(String pan);

  Future<AbroadTransferRateEntity> getTransferRate({
    required int merchantId,
    required String pan,
    double? payAmount,
  });
}
