import 'package:mobile_ultra/data/api/dto/responses/home/monthly_cashback_response.dart';
import 'package:mobile_ultra/domain/home/monthly_cashback_entity.dart';

extension MonthlyCashbackResponseToEntity on MonthlyCashbackResponse {
  MonthlyCashbackEntity toEntity() => MonthlyCashbackEntity(
        amount: data.amount.toDouble(),
        currentMonth: data.currentMonth,
      );
}
