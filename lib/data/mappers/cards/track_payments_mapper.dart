import 'package:mobile_ultra/data/api/dto/responses/cards/track_payments_response.dart';
import 'package:mobile_ultra/domain/cards/track_payments_entity.dart';

extension TrackPaymentsResponseToEntityExt on TrackPaymentsResponse {
  TrackPaymentsEntity toEntity() {
    return TrackPaymentsEntity(
      success: success,
      subscribedDate: subscribedDate,
    );
  }
}
