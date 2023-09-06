import 'package:elementary/elementary.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/card/main_presenter.dart';
import 'package:mobile_ultra/screens/auth/auth_pin_model.dart';
import 'package:mobile_ultra/screens/auth/auth_pin_screen.dart';
import 'package:mobile_ultra/screens/base/mwwm/auth/auth_wm.dart';
import 'package:mobile_ultra/utils/inject.dart';

abstract class IAuthPinScreenWidgetModel extends IWidgetModel {
  void login({
    required void onLogin({
      String? errorMessage,
      bool confirmBySMS,
    }),
  });

  bool get isBiometricsEnabled;
  bool get isQuickPayOnboardingDisplayed;
  bool get isOnboardingDisplayed;
}

class AuthPinScreenWidgetModel extends WidgetModel<AuthPinScreen, AuthPinModel>
    with AuthWidgetModelMixin
    implements IAuthPinScreenWidgetModel {
  AuthPinScreenWidgetModel(super.model);

  @override
  bool get isBiometricsEnabled => model.isBiometricsEnabled;

  @override
  bool get isQuickPayOnboardingDisplayed => model.isQuickPayOnboardingDisplayed;

  @override
  bool get isOnboardingDisplayed => model.isOnboardingDisplayed;

  @override
  void login({
    required void onLogin({
      String? errorMessage,
      bool confirmBySMS,
    }),
  }) async {
    await refreshToken();

    if (authStatus == AuthStatus.success) {
      await db!.readStoredCards();
      MainPresenter.cardList(
        onSussecc: onLogin,
        onError: (
          String error, {
          dynamic errorBody,
        }) {
          return onLogin(
            errorMessage: (errorBody != null && errorBody is Map)
                ? errorBody['detail']
                : null,
          );
        },
      );
    } else if (authStatus != AuthStatus.invalidToken) {
      onLogin(
        errorMessage: locale.getText(authStatus.message!),
        confirmBySMS: authStatus == AuthStatus.activationCodeSent,
      );
    }
  }
}

AuthPinScreenWidgetModel authPinScreenWidgetModelFactory(_) =>
    AuthPinScreenWidgetModel(
      AuthPinModel(
        inject(),
        inject(),
        inject(),
        inject(),
      ),
    );
