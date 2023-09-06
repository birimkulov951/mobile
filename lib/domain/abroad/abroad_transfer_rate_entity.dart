import 'package:equatable/equatable.dart';

class AbroadTransferRateEntity with EquatableMixin {
  AbroadTransferRateEntity({
    required this.rate,
    required this.minAmount,
    required this.maxAmount,
    required this.amount,
    required this.payAmount,
    required this.billId,
  });

  final double rate;
  final int minAmount;
  final int maxAmount;
  final double amount;
  final double payAmount;
  final int billId;

  @override
  List<Object> get props => [
        rate,
        minAmount,
        maxAmount,
        amount,
        payAmount,
        billId,
      ];
}
