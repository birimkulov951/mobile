import 'package:elementary/elementary.dart';
import 'package:mobile_ultra/domain/feedback/feedback_entity.dart';
import 'package:mobile_ultra/repositories/feedback_repository.dart';

class FeedbackBottomSheetsModel extends ElementaryModel {
  FeedbackBottomSheetsModel(this._feedbackRepository);

  final FeedbackRepository _feedbackRepository;

  Future<void> postFeedback(FeedbackEntity feedbackEntity) async {
    try {
      await _feedbackRepository.postFeedback(feedbackEntity);
    } on Object catch (e) {
      this.handleError(e);
    }
  }
}
