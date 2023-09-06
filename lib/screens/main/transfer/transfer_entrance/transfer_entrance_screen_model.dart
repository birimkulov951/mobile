import 'package:elementary/elementary.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_ultra/domain/cards_by_phone_number/cards_by_phone_number_entity.dart';
import 'package:mobile_ultra/domain/transfer/p2p_info_entity.dart';
import 'package:mobile_ultra/domain/transfer/previous_transfer_entity.dart';
import 'package:mobile_ultra/repositories/remote_config_repository.dart';
import 'package:mobile_ultra/repositories/system_repository.dart';
import 'package:mobile_ultra/repositories/transfer_repository.dart';
import 'package:mobile_ultra/screens/base/mwwm/remote_config/remote_config_model.dart';
import 'package:mobile_ultra/screens/base/mwwm/system/system_model.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:paynet_uikit/paynet_uikit.dart';

class TransferEntranceScreenModel extends ElementaryModel
    with SystemModelMixin, RemoteConfigModelMixin {
  TransferEntranceScreenModel({
    required RemoteConfigRepository remoteConfigRepository,
    required SystemRepository systemRepository,
    required this.transferRepository,
  }) {
    this.systemRepository = systemRepository;
    this.remoteConfigRepository = remoteConfigRepository;
  }

  @protected
  final TransferRepository transferRepository;

  Future<List<PreviousTransferEntity>> fetchPreviousTransfers() async {
    try {
      final response = await transferRepository.fetchPreviousTransfers();
      return response;
    } on Object catch (e) {
      handleError(e);
      return [];
    }
  }

  Future<BankCardsEntity?> getBankCardsPhoneNumber(String phoneNumber) async {
    phoneNumber = phoneNumber.replaceAll('+', '');
    try {
      if (getPhoneProvider(phoneNumber) !=
          null) {
        final cardsByPhoneNumberEntity =
            await transferRepository.getCardsByPhoneNumber(phoneNumber);
        if (!cardsByPhoneNumberEntity.success) {
          throw Exception();
        }
        return cardsByPhoneNumberEntity.bankCardsData;
      } else {
        throw Exception();
      }
    } on Object catch (error) {
      handleError(error);
    }
    return null;
  }

  Future<P2PInfoEntity?> getP2PInfoByPan(String pan) async {
    try {
      if (isHumo(pan)) {
        return await transferRepository.getP2PInfoByHumoPan(
            pan: pan, receiverCardType: Const.HUMO);
      } else if (isUzcard(pan)) {
        return await transferRepository.getP2PInfoByUzcardPan(
            pan: pan, receiverCardType: Const.UZCARD);
      } else {
        throw Exception();
      }
    } on Object catch (error) {
      handleError(error);
    }
    return null;
  }
}
