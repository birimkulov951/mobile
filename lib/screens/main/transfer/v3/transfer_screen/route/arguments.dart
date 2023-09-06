import 'package:equatable/equatable.dart';
import 'package:mobile_ultra/domain/transfer/transfer_way_entity.dart';

class TransferScreenArguments with EquatableMixin {
  final TransferWayEntity transferWay;

  const TransferScreenArguments({required this.transferWay});

  @override
  List<Object?> get props => [transferWay];
}
