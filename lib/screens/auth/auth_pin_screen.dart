import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/screens/auth/auth_pin.dart';
import 'package:mobile_ultra/screens/auth/auth_pin_screen_wm.dart';
import 'package:mobile_ultra/screens/auth/route/auth_pin_screen_arguments.dart';

class AuthPinScreen
    extends ElementaryWidget<IAuthPinScreenWidgetModel> {
  const AuthPinScreen({
    Key? key,
    required this.arguments,
  }) : super(authPinScreenWidgetModelFactory, key: key);

  final AuthPinScreenArguments arguments;

  @override
  Widget build(IAuthPinScreenWidgetModel wm) {
    return AuthPinWidget(wm: wm);
  }
}
