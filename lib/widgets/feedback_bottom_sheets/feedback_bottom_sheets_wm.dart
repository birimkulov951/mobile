import 'dart:io';

import 'package:dio/dio.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/feedback/feedback_entity.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/ui_models/toast/toast.dart';
import 'package:mobile_ultra/utils/inject.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/utils/url_launcher.dart';
import 'package:mobile_ultra/widgets/feedback_bottom_sheets/feedback_bottom_sheets.dart';
import 'package:mobile_ultra/widgets/feedback_bottom_sheets/feedback_bottom_sheets_model.dart';
import 'package:url_launcher/url_launcher.dart';

const _playStoreUrlLink =
    "";

enum BottomSheetStatus {
  chooseOption,
  positive,
  negative,
}

abstract class IFeedbackBottomSheetsWidgetModel extends IWidgetModel {
  abstract final StateNotifier<BottomSheetStatus> bottomSheetStatusState;

  abstract final StateNotifier<bool> isFirstStepLoadingState;

  void onPressAllGoodButton();

  void onPressSomethingWrongButton();

  void onPressRateApp();

  void onPressNextTime();

  abstract final StateNotifier<bool> isFeedbackFieldEmptyState;

  abstract final StateNotifier<bool> isNegativeFeedbackLoadingState;

  abstract final TextEditingController feedbackFieldController;

  void onTapCleanFeedbackField();

  void onPressSendFeedback();

  void hideKeyboard();
}

class FeedbackBottomSheetsWidgetModel
    extends WidgetModel<FeedbackBottomSheets, FeedbackBottomSheetsModel>
    implements IFeedbackBottomSheetsWidgetModel {
  FeedbackBottomSheetsWidgetModel(FeedbackBottomSheetsModel model)
      : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    feedbackFieldController.addListener(_checkIfFieldEmpty);
  }

  @override
  void dispose() {
    super.dispose();
    feedbackFieldController.removeListener(_checkIfFieldEmpty);
    feedbackFieldController.dispose();
  }

  @override
  final StateNotifier<BottomSheetStatus> bottomSheetStatusState =
      StateNotifier(initValue: BottomSheetStatus.chooseOption);

  @override
  void onPressAllGoodButton() async {
    isFirstStepLoadingState.accept(true);
    try {
      await model.postFeedback(
          FeedbackEntity(feedbackStatus: FeedbackStatus.satisfied));
      isFirstStepLoadingState.accept(false);
      bottomSheetStatusState.accept(BottomSheetStatus.positive);
    } on DioError catch (e) {
      printLog("Feedback WM error: ${e.error} - ${e.response}");
      isFirstStepLoadingState.accept(false);
    }
  }

  @override
  final StateNotifier<bool> isFirstStepLoadingState =
      StateNotifier(initValue: false);

  @override
  void onPressSomethingWrongButton() {
    bottomSheetStatusState.accept(BottomSheetStatus.negative);
  }

  @override
  void onPressNextTime() {
    Navigator.of(context).pop(FeedbackStatus.satisfied);
  }

  @override
  void onPressRateApp() async {
    Platform.isAndroid
        ? await UrlLauncher.launchUrl(
            _playStoreUrlLink,
            mode: LaunchMode.externalApplication,
          )
        : channel.openAppStore();
    Navigator.of(context).pop(FeedbackStatus.satisfied);
  }

  @override
  final TextEditingController feedbackFieldController = TextEditingController();

  @override
  final StateNotifier<bool> isFeedbackFieldEmptyState =
      StateNotifier(initValue: true);

  @override
  final StateNotifier<bool> isNegativeFeedbackLoadingState =
      StateNotifier(initValue: false);

  @override
  void onPressSendFeedback() async {
    isNegativeFeedbackLoadingState.accept(true);
    await model.postFeedback(FeedbackEntity(
      feedbackStatus: FeedbackStatus.unsatisfied,
      comment: feedbackFieldController.text,
    ));
    isNegativeFeedbackLoadingState.accept(false);
    Navigator.of(context).pop(FeedbackStatus.unsatisfied);
    Toast.show(
      context,
      title: locale.getText('thanks_for_opinion'),
      type: ToastType.success,
    );
  }

  @override
  void onTapCleanFeedbackField() {
    feedbackFieldController.clear();
    isFeedbackFieldEmptyState.accept(true);
  }

  void _checkIfFieldEmpty() {
    if (feedbackFieldController.text.isEmpty) {
      isFeedbackFieldEmptyState.accept(true);
    } else if (isFeedbackFieldEmptyState.value == true) {
      isFeedbackFieldEmptyState.accept(false);
    }
  }

  @override
  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

FeedbackBottomSheetsWidgetModel feedbackBottomSheetsWidgetModelFactory(_) =>
    FeedbackBottomSheetsWidgetModel(FeedbackBottomSheetsModel(inject()));
