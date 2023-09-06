import 'package:equatable/equatable.dart';

class FeedbackEntity with EquatableMixin {
  final FeedbackStatus feedbackStatus;
  final String? comment;

  const FeedbackEntity({
    required this.feedbackStatus,
    this.comment,
  });

  @override
  List<Object?> get props => [
        feedbackStatus,
        comment,
      ];
}

enum FeedbackStatus {
  satisfied,
  unsatisfied,
  undefined,
}

extension FeedbackStatusExt on FeedbackStatus {
  String get name {
    switch (this) {
      case FeedbackStatus.satisfied:
        return "SATISFIED";
      case FeedbackStatus.unsatisfied:
        return "UNSATISFIED";
      case FeedbackStatus.undefined:
        return "UNDEFINED";
    }
  }
}
