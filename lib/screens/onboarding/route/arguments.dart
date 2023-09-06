import 'package:equatable/equatable.dart';
import 'package:mobile_ultra/domain/onboarding/onboarding_entity.dart';

class OnBoardingScreenArguments with EquatableMixin {
  const OnBoardingScreenArguments({
    required this.entities,
    this.isQuickPayOnboarding = false,
  });

  final bool isQuickPayOnboarding;
  final List<OnBoardingEntity> entities;

  @override
  List<Object> get props => [
        isQuickPayOnboarding,
        entities,
      ];

  @override
  String toString() {
    return 'OnBoardingScreenParams{'
        'isQuickPayOnboarding: $isQuickPayOnboarding, entities: $entities}';
  }
}
