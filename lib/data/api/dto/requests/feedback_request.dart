import 'package:json_annotation/json_annotation.dart';

part 'feedback_request.g.dart';

@JsonSerializable()
class FeedbackRequest {
  @JsonKey(name: "feedback_status")
  final String feedbackStatus;
  final String? comment;

  const FeedbackRequest({
    required this.feedbackStatus,
    this.comment,
  });

  Map<String, dynamic> toJson() => _$FeedbackRequestToJson(this);
}
