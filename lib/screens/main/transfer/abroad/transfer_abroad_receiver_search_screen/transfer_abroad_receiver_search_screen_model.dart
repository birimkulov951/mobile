import 'package:elementary/elementary.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_ultra/domain/abroad/abroad_transfer_receiver_entity.dart';
import 'package:mobile_ultra/repositories/system_repository.dart';
import 'package:mobile_ultra/repositories/transfer_abroad_repository.dart';
import 'package:mobile_ultra/screens/base/mwwm/system/system_model.dart';
import 'package:mobile_ultra/screens/base/mwwm/transfer/transfer_rate_model.dart';

class TransferAbroadReceiverSearchScreenModel extends ElementaryModel
    with  SystemModelMixin, TransferRateModelMixin {
  TransferAbroadReceiverSearchScreenModel({
    required SystemRepository systemRepository,
    required SystemRepository permissionRepository,
    required this.transferAbroadRepository,
  }) {
    this.systemRepository = systemRepository;
  }

  @override
  @protected
  final TransferAbroadRepository transferAbroadRepository;

  Future<List<AbroadTransferReceiverEntity>?> fetchLastReceivers() async {
    try {
      return await transferAbroadRepository.getLastReceivers();
    } on Object catch (error) {
      this.handleError(error);
    }
    return null;
  }

  Future<AbroadTransferReceiverEntity?> findReceiverByPan(String pan) async {
    try {
      return await transferAbroadRepository.getReceiverByPan(pan);
    } on Object catch (error) {
      this.handleError(error);
    }
    return null;
  }
}
