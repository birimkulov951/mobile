import 'package:equatable/equatable.dart';

class TransferCommissionEntity with EquatableMixin {
  final int senderCardType;
  final int receiverCardType;
  final double commission;

  TransferCommissionEntity({
    required this.senderCardType,
    required this.receiverCardType,
    required this.commission,
  });

  @override
  List<Object?> get props => [
        senderCardType,
        receiverCardType,
        commission,
      ];
}
