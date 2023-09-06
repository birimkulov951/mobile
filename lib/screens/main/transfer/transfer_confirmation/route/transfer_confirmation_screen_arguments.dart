import 'package:equatable/equatable.dart';
import 'package:mobile_ultra/interactor/analytics/data/transfer_destination_type.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/transfer/model/p2p_check.dart';

class TransferConfirmationScreenArguments with EquatableMixin {
  final AttachedCard? fromCard;
  final P2PCheck? p2pResult;
  final String? amounts;
  final String? keyComments;
  final int? receiverCardTypes;
  final double? commissionChange;
  final double? commissionAmount;
  final bool? isOther;
  final TransferDestinationType? destinationType;
  final String comment;
  final bool isAddTemplateButtonHidden;
  final String? receiverCardIdentifier;

  const TransferConfirmationScreenArguments({
    required this.fromCard,
    required this.p2pResult,
    required this.amounts,
    required this.keyComments,
    required this.receiverCardTypes,
    required this.commissionChange,
    required this.commissionAmount,
    required this.isOther,
    required this.destinationType,
    required this.comment,
    required this.isAddTemplateButtonHidden,
    this.receiverCardIdentifier,
  });

  @override
  List<Object?> get props => [
        fromCard,
        p2pResult,
        amounts,
        keyComments,
        receiverCardTypes,
        commissionChange,
        commissionAmount,
        isOther,
        destinationType,
        comment,
        isAddTemplateButtonHidden,
        receiverCardIdentifier,
      ];
}
