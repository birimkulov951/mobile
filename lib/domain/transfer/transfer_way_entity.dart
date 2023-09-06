import 'package:mobile_ultra/domain/cards_by_phone_number/cards_by_phone_number_entity.dart';
import 'package:mobile_ultra/domain/common/p2p_check_type.dart';
import 'package:mobile_ultra/domain/transfer/p2p_info_entity.dart';
import 'package:mobile_ultra/domain/transfer/previous_transfer_entity.dart';
import 'package:mobile_ultra/domain/transfer/template_entity.dart';
import 'package:mobile_ultra/interactor/analytics/data/transfer_destination_type.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:ui_kit/ui_kit.dart' as uikit;

abstract class TransferWayEntity {
  TransferWayEntity();

  TransferDestinationType get destinationType {
    final transferWay = this;
    if (transferWay is TransferWayByOwnCardEntity) {
      return TransferDestinationType.cardLinked;
    } else if (transferWay is TransferWayByBankCard) {
      return TransferDestinationType.phone;
    } else {
      return TransferDestinationType.cardExternal;
    }
  }

  String? get expDate {
    final transferWay = this;
    if (transferWay is TransferWayByOwnCardEntity) {
      return transferWay.ownCard.expDate!;
    }
    if (transferWay is TransferWayByP2PInfoEntity) {
      return transferWay.p2pInfo.exp!;
    }
    if (transferWay is TransferWayBySavedTransfer) {
      return transferWay.expDate;
    }
    if (transferWay is TransferWayByBankCard) {
      return transferWay.bankCard.expiry;
    }
    if (transferWay is TransferWayByTemplate) {
      return transferWay.template.exp.toString();
    }
    return null;
  }

  P2PCheckType get checkCardType {
    final transferWay = this;
    if (transferWay is TransferWayByP2PInfoEntity) {
      return P2PCheckType.pan;
    }
    if (transferWay is TransferWayByBankCard) {
      if (transferWay.bankCard.cardType == Const.HUMO) {
        return P2PCheckType.pan;
      } else {
        return P2PCheckType.phone;
      }
    }
    if (transferWay is TransferWayByOwnCardEntity) {
      if (transferWay.ownCard.type == Const.HUMO) {
        return P2PCheckType.pan;
      } else {
        return P2PCheckType.cardToken;
      }
    }
    if (transferWay is TransferWayBySavedTransfer) {
      final previousTransfer = transferWay.previousTransfer;
      if (previousTransfer is PreviousTransferByTokenEntity) {
        return previousTransfer.checkType;
      } else {
        return P2PCheckType.pan;
      }
    }
    if (transferWay is TransferWayByTemplate) {
      if (transferWay.template.receiverCardType == Const.HUMO) {
        return P2PCheckType.pan;
      } else {
        return P2PCheckType.cardToken;
      }
    }
    return P2PCheckType.cardToken;
  }

  String get cardId {
    final transferWay = this;
    if (transferWay is TransferWayByOwnCardEntity) {
      return transferWay.ownCard.token!;
    }
    if (transferWay is TransferWayByP2PInfoEntity) {
      return transferWay.p2pInfo.pan;
    }
    if (transferWay is TransferWayBySavedTransfer) {
      final previousTransfer = transferWay.previousTransfer;
      if (previousTransfer is PreviousTransferByTokenEntity) {
        return previousTransfer.token;
      } else if (previousTransfer is PreviousTransferByPanEntity) {
        return previousTransfer.pan;
      }
    }
    if (transferWay is TransferWayByBankCard) {
      return transferWay.bankCard.id;
    }
    if (transferWay is TransferWayByTemplate) {
      return transferWay.template.id2;
    }
    return '';
  }

  int get cardType {
    final transferWay = this;
    if (transferWay is TransferWayByOwnCardEntity) {
      return transferWay.ownCard.type!;
    }
    if (transferWay is TransferWayByP2PInfoEntity) {
      return transferWay.p2pInfo.receiverCardType!;
    }
    if (transferWay is TransferWayBySavedTransfer) {
      return transferWay.previousTransfer.type;
    }
    if (transferWay is TransferWayByBankCard) {
      return transferWay.bankCard.cardType;
    }
    if (transferWay is TransferWayByTemplate) {
      return transferWay.template.receiverCardType;
    }
    return 0;
  }

  String? get receiverBankName {
    final transferWay = this;
    if (transferWay is TransferWayByBankCard) {
      return transferWay.bankCard.bank.bankName;
    }
    return null;
  }

  String get cardName {
    final transferWay = this;
    if (transferWay is TransferWayByOwnCardEntity) {
      return transferWay.ownCard.name!;
    }
    if (transferWay is TransferWayByP2PInfoEntity) {
      return transferWay.p2pInfo.fio;
    }
    if (transferWay is TransferWayBySavedTransfer) {
      return transferWay.previousTransfer.name;
    }
    if (transferWay is TransferWayByBankCard) {
      return transferWay.bankCard.fullName;
    }
    if (transferWay is TransferWayByTemplate) {
      return transferWay.template.fio;
    }
    return '';
  }

  String get displayedPan {
    final transferWay = this;
    if (transferWay is TransferWayByP2PInfoEntity) {
      return uikit.formatCardNumber(transferWay.p2pInfo.pan);
    }
    if (transferWay is TransferWayBySavedTransfer) {
      return transferWay.previousTransfer.maskedPan;
    }
    if (transferWay is TransferWayByBankCard) {
      return transferWay.bankCard.maskedPan;
    }
    return '';
  }

  factory TransferWayEntity.fromP2PInfo(P2PInfoEntity p2pInfo) {
    return TransferWayByP2PInfoEntity(p2pInfo: p2pInfo);
  }

  factory TransferWayEntity.fromOwnCard(AttachedCard ownCard) {
    return TransferWayByOwnCardEntity(
      ownCard: ownCard,
    );
  }

  factory TransferWayEntity.fromPreviousTransfer(
    PreviousTransferEntity previousTransfer, {
    String? expDate,
  }) {
    return TransferWayBySavedTransfer(
      previousTransfer: previousTransfer,
      expDate: expDate,
    );
  }

  factory TransferWayEntity.fromBankCard(BankCardEntity bankCard) {
    return TransferWayByBankCard(bankCard: bankCard);
  }

  factory TransferWayEntity.fromTemplate(TemplateEntity templateEntity) {
    return TransferWayByTemplate(template: templateEntity);
  }
}

class TransferWayByP2PInfoEntity extends TransferWayEntity {
  TransferWayByP2PInfoEntity({required this.p2pInfo});

  final P2PInfoEntity p2pInfo;

  @override
  String toString() {
    return 'TransferWayByP2PInfoEntity{p2pInfo: $p2pInfo}';
  }
}

class TransferWayByOwnCardEntity extends TransferWayEntity {
  TransferWayByOwnCardEntity({required this.ownCard});

  final AttachedCard ownCard;

  TransferWayByOwnCardEntity copyWith({AttachedCard? ownCard}) {
    return TransferWayByOwnCardEntity(
      ownCard: ownCard ?? this.ownCard,
    );
  }
}

class TransferWayBySavedTransfer extends TransferWayEntity {
  TransferWayBySavedTransfer({
    required this.previousTransfer,
    required this.expDate,
  });

  final PreviousTransferEntity previousTransfer;
  @override
  final String? expDate;

  TransferWayBySavedTransfer copyWith(
      {PreviousTransferEntity? previousTransfer, String? expDate}) {
    return TransferWayBySavedTransfer(
      previousTransfer: previousTransfer ?? this.previousTransfer,
      expDate: expDate ?? this.expDate,
    );
  }
}

class TransferWayByBankCard extends TransferWayEntity {
  TransferWayByBankCard({required this.bankCard});

  final BankCardEntity bankCard;

  @override
  String toString() {
    return 'TransferWayByBankCard{bankCard: $bankCard}';
  }
}

class TransferWayByTemplate extends TransferWayEntity {
  TransferWayByTemplate({required this.template});

  final TemplateEntity template;

  @override
  String toString() {
    return 'TransferWayByTemplate{templateEntity: $template}';
  }
}
