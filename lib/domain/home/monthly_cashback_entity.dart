import 'package:equatable/equatable.dart';

class MonthlyCashbackEntity with EquatableMixin {
  const MonthlyCashbackEntity({
    required this.amount,
    required this.currentMonth,
  });

  final double amount;
  final int currentMonth;

  @override
  List<Object> get props => [
        amount,
        currentMonth,
      ];
}
