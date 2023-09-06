import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/screens/registration/otp_confirmation/otp_confirmation_wm.dart';
import 'package:mobile_ultra/screens/registration/otp_confirmation/route/otp_confirmation_screen_arguments.dart';
import 'package:mobile_ultra/screens/registration/otp_confirmation/step_3_confirm_sms_code.dart';

class OtpConfirmationScreen
    extends ElementaryWidget<IOtpConfirmationScreenWidgetModel> {
  const OtpConfirmationScreen({
    Key? key,
    required this.arguments,
  }) : super(otpConfirmationScreenWidgetModelFactory, key: key);

  final OtpConfirmationScreenArguments arguments;

  @override
  Widget build(IOtpConfirmationScreenWidgetModel wm) {
    return ConfirmSMSWidget(
      isAuth: arguments.isAuth,
      phone: arguments.phoneNumber,
      wm: wm,
    );
  }
}
