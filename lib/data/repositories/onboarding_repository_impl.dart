import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/storages/onboarding_storage.dart';
import 'package:mobile_ultra/repositories/onboarding_repository.dart';

@Singleton(as: OnboardingRepository)
class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(this._onboardingStorage);

  final OnboardingStorage _onboardingStorage;

  @override
  bool get isOnboardingDisplayed => _onboardingStorage.isOnboardingDisplayed;

  @override
  Future<void> setIsOnboardingDisplayed(final bool isDisplayed) async =>
      _onboardingStorage.setIsOnboardingDisplayed(isDisplayed);

  @override
  bool get isQuickPayOnboardingDisplayed =>
      _onboardingStorage.isQuickPayOnboardingDisplayed;

  @override
  Future<void> setIsQuickPayOnboardingDisplayed(final bool isDisplayed) async =>
      _onboardingStorage.setIsQuickPayOnboardingDisplayed(isDisplayed);
}
