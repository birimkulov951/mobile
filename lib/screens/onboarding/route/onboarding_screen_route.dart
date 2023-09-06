import 'package:flutter/material.dart';
import 'package:mobile_ultra/screens/onboarding/onboarding_screen.dart';
import 'package:mobile_ultra/screens/onboarding/route/arguments.dart';

class OnBoardingScreenRoute extends MaterialPageRoute {
  OnBoardingScreenRoute(OnBoardingScreenArguments arguments)
      : super(
          builder: _buildScreen,
          settings: RouteSettings(name: Tag, arguments: arguments),
        );

  static const Tag = '/onboardingScreen';

  static Widget _buildScreen(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as OnBoardingScreenArguments;
    return OnBoardingScreen(arguments: arguments);
  }

  static MapEntry<String, WidgetBuilder> get mapEntry {
    return const MapEntry<String, WidgetBuilder>(Tag, _buildScreen);
  }
}
