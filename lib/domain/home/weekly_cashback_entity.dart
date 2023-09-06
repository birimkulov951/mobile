import 'package:equatable/equatable.dart';
import 'package:mobile_ultra/domain/home/daily_cashback_entity.dart';

class WeeklyCashbackEntity with EquatableMixin {
  const WeeklyCashbackEntity({
    required this.todayCashback,
    required this.maxCashbackInWeek,
    required this.weeklyCashback,
  });

  final double maxCashbackInWeek;
  final DailyCashbackEntity todayCashback;
  final List<DailyCashbackEntity> weeklyCashback;

  @override
  List<Object> get props => [
        todayCashback,
        maxCashbackInWeek,
        weeklyCashback,
      ];
}
