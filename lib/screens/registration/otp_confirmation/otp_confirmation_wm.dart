import 'package:elementary/elementary.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/card/main_presenter.dart';
import 'package:mobile_ultra/screens/base/mwwm/auth/auth_wm.dart';
import 'package:mobile_ultra/screens/registration/otp_confirmation/otp_confirmation_model.dart';
import 'package:mobile_ultra/screens/registration/otp_confirmation/otp_confirmation_screen.dart';
import 'package:mobile_ultra/utils/inject.dart';

abstract class IOtpConfirmationScreenWidgetModel extends IWidgetModel {
  void login({
    required String otpCode,
    required void onLogin({
      String? errorMessage,
    }),
  });

  void reFetchLoginOtp();
}

class OtpConfirmationScreenWidgetModel
    extends WidgetModel<OtpConfirmationScreen, OtpConfirmationModel>
    with AuthWidgetModelMixin
    implements IOtpConfirmationScreenWidgetModel {
  OtpConfirmationScreenWidgetModel(
    super.model,
  );

  @override
  void reFetchLoginOtp() async {
    await model.fetchLoginOtp(widget.arguments.phoneNumber);
  }

  @override
  void login({
    required String otpCode,
    required void onLogin({
      String? errorMessage,
    }),
  }) async {
    await loginByOtp(
      phoneNumber: widget.arguments.phoneNumber,
      otpCode: otpCode,
    );

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
    } else {
      onLogin(
        errorMessage: authStatus.message!,
      );
    }
  }
}

OtpConfirmationScreenWidgetModel otpConfirmationScreenWidgetModelFactory(_) =>
    OtpConfirmationScreenWidgetModel(
      OtpConfirmationModel(
        inject(),
        inject(),
      ),
    );
