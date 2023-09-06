import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/api/dto/requests/feedback_request.dart';
import 'package:mobile_ultra/data/mappers/entity_mapper_base.dart';
import 'package:mobile_ultra/domain/feedback/feedback_entity.dart';

@singleton
class FeedbackMapper extends CommonMapperBase<FeedbackEntity, FeedbackRequest> {
  @override
  FeedbackRequest toDTO(FeedbackEntity feedbackEntity) {
    return FeedbackRequest(
      feedbackStatus: feedbackEntity.feedbackStatus.name,
      comment: feedbackEntity.comment,
    );
  }

  @override
  FeedbackEntity toEntity(FeedbackRequest feedbackRequest) {
    throw UnimplementedError();
  }
}
