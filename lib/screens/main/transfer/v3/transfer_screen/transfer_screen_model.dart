import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/transfer/p2p_info_entity.dart';
import 'package:mobile_ultra/domain/transfer/previous_transfer_entity.dart';
import 'package:mobile_ultra/domain/transfer/transfer_commission_entity.dart';
import 'package:mobile_ultra/repositories/remote_config_repository.dart';
import 'package:mobile_ultra/repositories/transfer_repository.dart';
import 'package:mobile_ultra/screens/base/mwwm/remote_config/remote_config_model.dart';
import 'package:mobile_ultra/screens/base/mwwm/transfer/transfer_model.dart';
import 'package:mobile_ultra/utils/const.dart';

class TransferScreenModel extends ElementaryModel
    with RemoteConfigModelMixin, TransferMixin {
  TransferScreenModel({
    required RemoteConfigRepository remoteConfigRepository,
    required this.transferRepository,
  }) {
    this.remoteConfigRepository = remoteConfigRepository;
  }

  @override
  @protected
  final TransferRepository transferRepository;

  Future<List<TransferCommissionEntity>> getCommissions() async {
    return await transferRepository.getCommissions();
  }

  Future<P2PInfoEntity?> getP2PInfoForSelfTransfer({
    required String receiverCardToken,
    required String senderCardToken,
    required int senderCardType,
    required int receiverCardType,
    required int amount,
  }) async {
    try {
      if (receiverCardType == Const.HUMO) {
        return await transferRepository.getP2PInfoByHumoPan(
          pan: receiverCardToken,
          senderCardToken: senderCardToken,
          senderCardType: senderCardType,
          receiverCardType: receiverCardType,
          amount: amount,
        );
      } else {
        return await transferRepository.getP2PInfoByToken(
          receiverCardToken: receiverCardToken,
          senderCardToken: senderCardToken,
          senderCardType: senderCardType,
          receiverCardType: receiverCardType,
          amount: amount,
        );
      }
    } on Object catch (error) {
      this.handleError(error);
    }
    return null;
  }

  Future<P2PInfoEntity?> getP2PInfoForSavedTransfer({
    required PreviousTransferEntity previousTransferEntity,
    required String senderCardToken,
    required int senderCardType,
    required int receiverCardType,
    required int amount,
  }) async {
    try {
      if (previousTransferEntity is PreviousTransferByTokenEntity) {
        return await transferRepository.getP2PInfoByPhoneNumber(
          maskedPan: previousTransferEntity.maskedPan,
          id: previousTransferEntity.token,
          bankName: previousTransferEntity.bankName,
          fullName: previousTransferEntity.name,
          cardType: previousTransferEntity.type,
        );
      } else if (previousTransferEntity is PreviousTransferByPanEntity) {
        if (receiverCardType == Const.HUMO) {
          return await transferRepository.getP2PInfoByHumoPan(
            pan: previousTransferEntity.pan,
            senderCardToken: senderCardToken,
            senderCardType: senderCardType,
            receiverCardType: receiverCardType,
            amount: amount,
          );
        } else {
          return await transferRepository.getP2PInfoByUzcardPan(
            pan: previousTransferEntity.pan,
            senderCardToken: senderCardToken,
            senderCardType: senderCardType,
            receiverCardType: receiverCardType,
            amount: amount,
          );
        }
      }
    } on Object catch (error) {
      this.handleError(error);
    }
    return null;
  }
}
