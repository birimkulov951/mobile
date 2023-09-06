import 'package:mobile_ultra/domain/cards_by_phone_number/cards_by_phone_number_entity.dart';
import 'package:mobile_ultra/domain/common/p2p_check_type.dart';
import 'package:mobile_ultra/domain/transfer/p2p_info_entity.dart';
import 'package:mobile_ultra/domain/transfer/p2p_payment_entity.dart';
import 'package:mobile_ultra/domain/transfer/previous_transfer_entity.dart';
import 'package:mobile_ultra/domain/transfer/transfer_commission_entity.dart';

abstract class TransferRepository {
  Future<CardsByPhoneNumberEntity> getCardsByPhoneNumber(String phoneNumber);

  Future<P2PInfoEntity> getP2PInfoByHumoPan({
    required String pan,
    String? senderCardToken,
    int? senderCardType,
    int? receiverCardType,
    int? amount,
  });

  Future<P2PInfoEntity> getP2PInfoByUzcardPan({
    required String pan,
    String? senderCardToken,
    int? senderCardType,
    int? receiverCardType,
    int? amount,
  });

  Future<P2PInfoEntity> getP2PInfoByPhoneNumber({
    required String id,
    required String bankName,
    required String fullName,
    required int cardType,
    required String maskedPan,
  });

  Future<P2PInfoEntity> getP2PInfoByToken({
    required String receiverCardToken,
    required String senderCardToken,
    required int senderCardType,
    required int receiverCardType,
    required int amount,
  });

  Future<List<PreviousTransferEntity>> fetchPreviousTransfers();

  Future<List<TransferCommissionEntity>> getCommissions();

  Future<P2PResultEntity> createP2PTransfer({
    required String receiverCardToken,
    required String senderCardToken,
    required String fio,
    required String? exp,
    required int senderCardType,
    required int receiverCardType,
    required int amount,
    required P2PCheckType receiverMethodType,
    required String? receiverBankName,
  });
}
