import 'package:equatable/equatable.dart';
import 'package:mobile_ultra/domain/common/p2p_check_type.dart';

abstract class PreviousTransferEntity with EquatableMixin {
  const PreviousTransferEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.name,
    required this.maskedPan,
    required this.date,
  });

  final int id;
  final int userId;
  final int type;
  final String name;
  final String maskedPan;
  final String date;

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        name,
        maskedPan,
        date,
      ];
}

class PreviousTransferByPanEntity extends PreviousTransferEntity {
  PreviousTransferByPanEntity({
    required this.pan,
    required super.id,
    required super.userId,
    required super.type,
    required super.name,
    required super.maskedPan,
    required super.date,
  });

  final String pan;

  @override
  List<Object?> get props => [
        ...super.props,
        pan,
      ];
}

class PreviousTransferByTokenEntity extends PreviousTransferEntity {
  PreviousTransferByTokenEntity({
    required this.token,
    required this.bankName,
    required this.checkType,
    required super.id,
    required super.userId,
    required super.type,
    required super.name,
    required super.maskedPan,
    required super.date,
  });

  final String token;
  final String bankName;
  final P2PCheckType checkType;

  @override
  List<Object?> get props => [
        ...super.props,
        token,
        bankName,
        checkType,
      ];
}
