import 'package:mobile_ultra/data/api/dto/responses/feedback_status_response.dart';
import 'package:mobile_ultra/domain/feedback/feedback_entity.dart';

abstract class FeedbackRepository {
  Future<FeedbackStatusResponse> getFeedbackStatus();

  Future<void> postFeedback(FeedbackEntity feedbackEntity);
}
