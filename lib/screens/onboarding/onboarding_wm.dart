import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_ultra/domain/onboarding/onboarding_entity.dart';
import 'package:mobile_ultra/interactor/analytics/analytics_interactor.dart';
import 'package:mobile_ultra/interactor/analytics/data/onboarding_finished_type.dart';
import 'package:mobile_ultra/screens/main/navigation.dart';
import 'package:mobile_ultra/screens/onboarding/onboarding_model.dart';
import 'package:mobile_ultra/screens/onboarding/onboarding_screen.dart';
import 'package:mobile_ultra/utils/inject.dart';

abstract class IOnBoardingWidgetModel extends IWidgetModel {
  abstract final PageController pageController;
  abstract final ValueNotifier<OnBoardingEntity> currentOnBoardingState;
  abstract final ValueNotifier<bool> isLastPageState;
  abstract final ValueNotifier<String> nextStepButtonTitleState;
  abstract final List<AnimationController> lottieControllers;
  double get viewPaddingBottom;
  int get pageIndex;
  void onLoaded(final LottieComposition composition);
  void onPageChanged(final int page);
  void dismiss();
  void onNext();
}

class OnBoardingWidgetModel
    extends WidgetModel<OnBoardingScreen, OnBoardingElementaryModel>
    with TickerProviderWidgetModelMixin
    implements IOnBoardingWidgetModel {
  OnBoardingWidgetModel(super.model);

  @override
  late final ValueNotifier<OnBoardingEntity> currentOnBoardingState;

  @override
  final ValueNotifier<bool> isLastPageState = ValueNotifier<bool>(false);

  @override
  final ValueNotifier<String> nextStepButtonTitleState =
      ValueNotifier<String>('next_step');

  @override
  final pageController = PageController();

  @override
  late final List<AnimationController> lottieControllers;

  @override
  double get viewPaddingBottom => MediaQuery.of(context).viewPadding.bottom;

  int _pageIndex = 0;

  @override
  int get pageIndex => _pageIndex;

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    lottieControllers = List.generate(
      widget.arguments.entities.length,
      (_) => AnimationController(vsync: this),
    );
    currentOnBoardingState =
        ValueNotifier<OnBoardingEntity>(widget.arguments.entities[pageIndex]);
    currentOnBoardingState.addListener(() {
      if (currentOnBoardingState.value == widget.arguments.entities.last) {
        isLastPageState.value = true;
        nextStepButtonTitleState.value = 'good';
      } else {
        isLastPageState.value = false;
        nextStepButtonTitleState.value = 'next_step';
      }
    });
  }

  @override
  void dispose() {
    for (final AnimationController controller in lottieControllers) {
      controller.dispose();
    }
    pageController.dispose();
    super.dispose();
  }

  @override
  void onPageChanged(final int page) {
    _pageIndex = page;
    currentOnBoardingState.value = widget.arguments.entities[pageIndex];
  }

  @override
  void onLoaded(final LottieComposition composition) {
    lottieControllers[pageIndex]
      ..duration = composition.duration
      ..forward();
  }

  @override
  void dismiss() {
    _closeOnboarding();
    if (widget.arguments.isQuickPayOnboarding) {
      model.setQuickPayOnboardingProgress(true);
    } else {
      model.setOnboardingProgress(true);
      AnalyticsInteractor.instance.onboardingTracker
          .trackOnboardingFinished(OnboardingProgress.skipped);
    }
  }

  @override
  void onNext() {
    if (currentOnBoardingState.value != widget.arguments.entities.last) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    } else {
      _closeOnboarding();
      if (widget.arguments.isQuickPayOnboarding) {
        model.setQuickPayOnboardingProgress(true);
      } else {
        model.setOnboardingProgress(true);
        AnalyticsInteractor.instance.onboardingTracker
            .trackOnboardingFinished(OnboardingProgress.passed);
      }
    }
  }

  void _closeOnboarding() {
    Navigator.pushReplacementNamed(context, NavigationWidget.Tag);
  }
}

OnBoardingWidgetModel onBoardingWidgetModelFactory(BuildContext context) =>
    OnBoardingWidgetModel(OnBoardingElementaryModel(inject()));
