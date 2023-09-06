import 'package:elementary/elementary.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_ultra/domain/abroad/abroad_transfer_rate_entity.dart';
import 'package:mobile_ultra/repositories/transfer_abroad_repository.dart';

mixin TransferRateModelMixin on ElementaryModel {
  @protected
  abstract final TransferAbroadRepository transferAbroadRepository;

  Future<AbroadTransferRateEntity?> getTransferRate({
    required int merchantId,
    required String pan,
    double? payAmount,
  }) async {
    try {
      return await transferAbroadRepository.getTransferRate(
        merchantId: merchantId,
        pan: pan,
        payAmount: payAmount,
      );
    } on Exception catch (error) {
      this.handleError(error);
    } on Object catch (error) {
      this.handleError(error);
    }
    return null;
  }
}
