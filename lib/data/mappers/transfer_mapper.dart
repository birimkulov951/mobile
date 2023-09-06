import 'package:mobile_ultra/data/api/dto/responses/cards_by_phone_number_response.dart';
import 'package:mobile_ultra/data/api/dto/responses/p2p_info_response.dart';
import 'package:mobile_ultra/data/api/dto/responses/p2p_payment_response.dart';
import 'package:mobile_ultra/data/api/dto/responses/saved_transfers_response.dart';
import 'package:mobile_ultra/data/api/dto/responses/transfer_commission_response.dart';
import 'package:mobile_ultra/domain/cards_by_phone_number/cards_by_phone_number_entity.dart';
import 'package:mobile_ultra/domain/common/p2p_check_type.dart';
import 'package:mobile_ultra/domain/transfer/p2p_info_entity.dart';
import 'package:mobile_ultra/domain/transfer/p2p_payment_entity.dart';
import 'package:mobile_ultra/domain/transfer/previous_transfer_entity.dart';
import 'package:mobile_ultra/domain/transfer/transfer_commission_entity.dart';
import 'package:mobile_ultra/net/transfer/model/p2p_pay.dart';

extension CardsByPhoneNumberEntityExt on CardsByPhoneNumberResponse {
  CardsByPhoneNumberEntity toEntity() {
    final List<BankCardEntity> paynetCards = [];
    final List<BankCardEntity> otherCards = [];

    for (final card in data.paynet) {
      paynetCards.add(
        BankCardEntity(
          id: card.id,
          cardType: card.cardType,
          maskedPan: card.maskedPan,
          fullName: card.fullName,
          expiry: card.expiry,
          bank: BankEntity(
            bankName: card.bank.bankName,
            logo: card.bank.logo,
          ),
        ),
      );
    }

    for (final card in data.other) {
      otherCards.add(
        BankCardEntity(
          id: card.id,
          cardType: card.cardType,
          maskedPan: card.maskedPan,
          fullName: card.fullName,
          expiry: card.expiry,
          bank: BankEntity(
            bankName: card.bank.bankName,
            logo: card.bank.logo,
          ),
        ),
      );
    }

    return CardsByPhoneNumberEntity(
      bankCardsData: BankCardsEntity(
        paynetCards: paynetCards,
        otherCards: otherCards,
      ),
      success: success,
    );
  }
}

extension P2PInfoEntityExt on P2PInfoResponse {
  P2PInfoEntity toEntity() {
    return P2PInfoEntity(
      pan: pan,
      fio: fio,
      commissionPercent: commissionPercent,
      limitIn: limitIn,
      limitOut: limitOut,
      exp: exp,
      receiverToken: receiverToken,
      receiverBankName: receiverBankName,
      userId: userId,
      commissionAmount: commissionAmount,
      commissionPrice: commissionPrice,
      max: max,
      min: min,
      senderCardType: senderCardType,
      receiverCardType: receiverCardType,
      amount: amount,
      type: type?.toP2PCheckType(),
    );
  }
}

extension SavedTransferEntityExt on SavedTransfer {
  PreviousTransferEntity toEntity() {
    if (token != null) {
      return PreviousTransferByTokenEntity(
        id: id,
        userId: userId,
        type: type,
        name: name,
        maskedPan: maskedPan,
        date: date,
        token: token!,
        bankName: bankName!,
        checkType: p2pCheckType!.toP2PCheckType(),
      );
    } else {
      return PreviousTransferByPanEntity(
        id: id,
        userId: userId,
        type: type,
        name: name,
        maskedPan: maskedPan,
        date: date,
        pan: pan!,
      );
    }
  }
}

extension TransferCommissionEntityExt on TransferCommissionResponse {
  TransferCommissionEntity toEntity() {
    return TransferCommissionEntity(
      senderCardType: sender,
      receiverCardType: receiver,
      commission: commission,
    );
  }
}

extension P2PPaymentEntityToOldModel on P2PResultEntity {
  P2Pay toP2Pay() {
    return P2Pay(
      amount: amount,
      amountCredit: amountCredit,
      id: id,
      commission: commission,
      pan1: senderMaskedPan,
      pan2: receiverMaskedPan,
      success: success,
      issuedDate: issuedDate,
    );
  }
}

extension P2PPaymentResponseToEntity on P2PPaymentResponse {
  P2PResultEntity toEntity() {
    return P2PResultEntity(
      amount: amount,
      amountCredit: amountCredit,
      id: id,
      commission: commission,
      senderMaskedPan: senderMaskedPan,
      receiverMaskedPan: receiverMaskedPan,
      success: success,
      issuedDate: issuedDate,
    );
  }
}
