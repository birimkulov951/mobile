import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_ultra/domain/onboarding/onboarding_entity.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/dimensions.dart';
import 'package:mobile_ultra/screens/onboarding/onboarding_wm.dart';
import 'package:mobile_ultra/screens/onboarding/route/arguments.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/locale_helper.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

final OnBoardingScreenArguments mainOnboardingArguments =
    OnBoardingScreenArguments(
  entities: <OnBoardingEntity>[
    OnBoardingEntity(
      title: locale.getText('onboarding2a'),
      description: locale.getText('onboarding2b'),
      assetPath: LocaleHelper.currentLangCode == LocaleHelper.Russian
          ? Assets.mainOnboardingLottieRu
          : Assets.mainOnboardingLottieUz,
    ),
    OnBoardingEntity(
      title: locale.getText('onboarding4a'),
      description: locale.getText('onboarding4b'),
      assetPath: LocaleHelper.currentLangCode == LocaleHelper.Russian
          ? Assets.mainOnboardingLottieRu2
          : Assets.mainOnboardingLottieUz2,
    ),
  ],
);

final OnBoardingScreenArguments quickPayOnboardingArguments =
    OnBoardingScreenArguments(
  isQuickPayOnboarding: true,
  entities: <OnBoardingEntity>[
    OnBoardingEntity(
      title: LocaleHelper.instance.getText('quick_pay_onboarding_title_1'),
      description: locale.getText('quick_pay_onboarding_description_1'),
      assetPath: LocaleHelper.currentLangCode == LocaleHelper.Russian
          ? Assets.quickPayOnboardingLottieRu
          : Assets.quickPayOnboardingLottieUz,
    ),
    OnBoardingEntity(
      title: LocaleHelper.instance.getText('quick_pay_onboarding_title_2'),
      description: locale.getText('quick_pay_onboarding_description_2'),
      assetPath: LocaleHelper.currentLangCode == LocaleHelper.Russian
          ? Assets.quickPayOnboardingLottieRu2
          : Assets.quickPayOnboardingLottieUz2,
    ),
  ],
);

class OnBoardingScreen extends ElementaryWidget<IOnBoardingWidgetModel> {
  const OnBoardingScreen({
    required this.arguments,
    super.key,
  }) : super(onBoardingWidgetModelFactory);

  final OnBoardingScreenArguments arguments;

  @override
  Widget build(IOnBoardingWidgetModel wm) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: BackgroundColors.Default,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 40,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 56,
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.only(right: Dimensions.unit2),
                        child: ValueListenableBuilder(
                          valueListenable: wm.isLastPageState,
                          builder: (
                            final BuildContext context,
                            final bool isLastPage,
                            final Widget? child,
                          ) {
                            return Visibility(
                              visible: !isLastPage,
                              child: GestureDetector(
                                onTap: wm.dismiss,
                                child: TextLocale(
                                  'dismiss',
                                  style: Typographies.captionButton,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: wm.currentOnBoardingState,
                        builder: (
                          final BuildContext context,
                          final OnBoardingEntity value,
                          final Widget? child,
                        ) =>
                            Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Lottie.asset(
                              value.assetPath,
                              key: ValueKey(wm.pageIndex),
                              controller: wm.lottieControllers[wm.pageIndex],
                              onLoaded: wm.onLoaded,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 35,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  constraints: const BoxConstraints(minHeight: 308 + 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.unit3),
                      topRight: Radius.circular(Dimensions.unit3),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.unit2,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(height: Dimensions.unit2),
                        Expanded(
                          child: PageView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: wm.pageController,
                            itemCount: arguments.entities.length,
                            itemBuilder: (BuildContext context, int index) =>
                                Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  arguments.entities[index].title,
                                  textAlign: TextAlign.start,
                                  style: Typographies.title2,
                                ),
                                const SizedBox(height: Dimensions.unit2),
                                Text(
                                  arguments.entities[index].description,
                                  textAlign: TextAlign.start,
                                  style: Typographies.textRegular,
                                ),
                              ],
                            ),
                            onPageChanged: wm.onPageChanged,
                          ),
                        ),
                        const SizedBox(height: Dimensions.unit1_5),
                        SmoothPageIndicator(
                          count: arguments.entities.length,
                          controller: wm.pageController,
                          effect: const ExpandingDotsEffect(
                            spacing: 8,
                            dotWidth: 4,
                            dotHeight: 4,
                            expansionFactor: 5,
                            dotColor: ColorNode.Green,
                            activeDotColor: ColorNode.Green,
                          ),
                        ),
                        const SizedBox(height: 28),
                        ValueListenableBuilder(
                          valueListenable: wm.nextStepButtonTitleState,
                          builder: (
                            final BuildContext context,
                            final String value,
                            final Widget? child,
                          ) =>
                              RoundedButton(
                            bg: ColorNode.Green,
                            title: value,
                            onPressed: wm.onNext,
                          ),
                        ),
                        SizedBox(
                          height: wm.viewPaddingBottom + Dimensions.unit2,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
