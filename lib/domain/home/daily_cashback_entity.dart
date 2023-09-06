import 'package:equatable/equatable.dart';

class DailyCashbackEntity with EquatableMixin {
  const DailyCashbackEntity({
    required this.amount,
    required this.date,
  });

  final double amount;
  final String date;

  @override
  List<Object> get props => [
        amount,
        date,
      ];
}
