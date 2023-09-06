import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';

import 'package:mobile_ultra/widgets/feedback_bottom_sheets/feedback_bottom_sheets_wm.dart';
import 'package:mobile_ultra/widgets/feedback_bottom_sheets/widgets/negative_feedback.dart';
import 'package:mobile_ultra/widgets/feedback_bottom_sheets/widgets/positive_feedback.dart';
import 'package:mobile_ultra/widgets/feedback_bottom_sheets/widgets/positive_negative_option.dart';

class FeedbackBottomSheets
    extends ElementaryWidget<IFeedbackBottomSheetsWidgetModel> {
  const FeedbackBottomSheets({Key? key})
      : super(feedbackBottomSheetsWidgetModelFactory, key: key);

  static Future show({required BuildContext context}) => showModalBottomSheet(
      context: context,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      isScrollControlled: true,
      builder: (_) {
        return FeedbackBottomSheets();
      });

  @override
  Widget build(IFeedbackBottomSheetsWidgetModel wm) {
    return StateNotifierBuilder(
      listenableState: wm.bottomSheetStatusState,
      builder: (context, status) {
        switch (status) {
          case BottomSheetStatus.positive:
            return PositiveFeedback(
              onPressNextTime: wm.onPressNextTime,
              onPressRateApp: wm.onPressRateApp,
            );
          case BottomSheetStatus.negative:
            return NegativeFeedback(
              isNegativeFeedbackLoadingState: wm.isNegativeFeedbackLoadingState,
              isFeedbackFieldEmptyState: wm.isFeedbackFieldEmptyState,
              hideKeyboard: wm.hideKeyboard,
              onTapCleanFeedbackField: wm.onTapCleanFeedbackField,
              onPressSendFeedback: wm.onPressSendFeedback,
              feedbackFieldController: wm.feedbackFieldController,
            );
          default:
            return PositiveNegativeOption(
              loadingState: wm.isFirstStepLoadingState,
              onPressAllGoodButton: wm.onPressAllGoodButton,
              onPressSomethingWrongButton: wm.onPressSomethingWrongButton,
            );
        }
      },
    );
  }
}
