import 'package:equatable/equatable.dart';
import 'package:mobile_ultra/domain/transfer/transfer_way_entity.dart';
import 'package:mobile_ultra/net/card/model/card.dart';

class TransferConfirmationScreenArguments with EquatableMixin {
  final AttachedCard senderCard;
  final TransferWayEntity transferWay;
  final int amount;
  final double commissionPercent;

  TransferConfirmationScreenArguments({
    required this.senderCard,
    required this.transferWay,
    required this.amount,
    required this.commissionPercent,
  });

  @override
  List<Object?> get props => [
        senderCard,
        transferWay,
        amount,
      ];
}
