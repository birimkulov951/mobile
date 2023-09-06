import 'package:mobile_ultra/data/api/dto/responses/home/daily_cashback_response.dart';
import 'package:mobile_ultra/data/api/dto/responses/home/weekly_cashback_response.dart';
import 'package:mobile_ultra/domain/home/daily_cashback_entity.dart';
import 'package:mobile_ultra/domain/home/weekly_cashback_entity.dart';

extension WeeklyCashbackResponseToEntity on WeeklyCashbackResponse {
  WeeklyCashbackEntity toEntity() => WeeklyCashbackEntity(
        todayCashback: todayCashback.toEntity(),
        maxCashbackInWeek: maxCashbackInWeek,
        weeklyCashback: weeklyCashback
            .map((dailyCashback) => dailyCashback.toEntity())
            .toList(),
      );
}

extension _DailyCashbackResponseToEntity on DailyCashbackResponse {
  DailyCashbackEntity toEntity() => DailyCashbackEntity(
        amount: amount,
        date: date,
      );
}
