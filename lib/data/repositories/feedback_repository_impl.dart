import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/api/dto/responses/feedback_status_response.dart';
import 'package:mobile_ultra/data/api/feedback_api.dart';
import 'package:mobile_ultra/data/mappers/feedback_mapper.dart';
import 'package:mobile_ultra/domain/feedback/feedback_entity.dart';
import 'package:mobile_ultra/repositories/feedback_repository.dart';

@Singleton(as: FeedbackRepository)
class FeedbackRepositoryImpl implements FeedbackRepository {
  final FeedbackApi _feedbackApi;
  final FeedbackMapper _feedbackMapper;

  const FeedbackRepositoryImpl(
    this._feedbackApi,
    this._feedbackMapper,
  );

  @override
  Future<FeedbackStatusResponse> getFeedbackStatus() async {
    return await _feedbackApi.getUserFeedbackStatus();
  }

  @override
  Future<void> postFeedback(FeedbackEntity feedbackEntity) async {
    return await _feedbackApi
        .sendFeedback(_feedbackMapper.toDTO(feedbackEntity));
  }
}
