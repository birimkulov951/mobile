import 'package:json_annotation/json_annotation.dart';

part 'feedback_status_response.g.dart';

@JsonSerializable()
class FeedbackStatusResponse {
  const FeedbackStatusResponse({required this.askForFeedback});

  @JsonKey(name: "success", defaultValue: false)
  final bool askForFeedback;

  factory FeedbackStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$FeedbackStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FeedbackStatusResponseToJson(this);
}
