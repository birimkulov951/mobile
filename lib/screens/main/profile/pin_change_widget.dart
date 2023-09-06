import 'package:flutter/material.dart';

import 'package:mobile_ultra/main.dart' show locale, pref;
import 'package:mobile_ultra/screens/base/base_pin_state.dart';
import 'package:mobile_ultra/screens/main/profile/profile.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

class PinChangeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PinChangeWidgetState();
}

class PinChangeWidgetState extends BasePinState<PinChangeWidget> {
  String _hint = '';

  String _oldPin = '';
  String _newPin = '';

  @override
  void initState() {
    super.initState();
    _hint = locale.getText('input_pin');
  }

  @override
  Widget get additionWidget => Text(
        locale.getText('forgot_code'),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: ColorNode.GreyScale500,
        ),
      );

  @override
  Widget get headerWidget => Container(
        height: MediaQuery.of(context).size.height * .38,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: TextLocale('change_pin'),
              titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            const Spacer(),
            Text(
              _hint,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: ColorNode.Dark3),
            ),
            SizedBox(
              height: 36,
            ),
          ],
        ),
      );

  @override
  void onAdditionWidgetPressed() => forgotCode();

  @override
  Future<bool> onBackPressed() async => true;

  @override
  void onPinEntered(String pin) {
    Future.delayed(Duration(milliseconds: 150), () {
      if (_oldPin.isEmpty) {
        String savedPin = aesDecrypt(pin, pref?.pinCode ?? '');
        if (pin != savedPin)
          onErrorPin();
        else {
          _oldPin = pin;
          _hint = locale.getText('input_new_pin');

          clearPin();
        }
      } else if (_newPin.isEmpty) {
        _newPin = pin;
        _hint = locale.getText('repeat_new_pin');

        clearPin();
      } else if (_newPin == pin) {
        pref?.setPin(aesEncrypt(_newPin, _newPin));
        Navigator.pop(context);
      } else {
        onErrorPin();
      }
    });
  }

  Future<void> forgotCode() async {
    final result = await viewModalSheet<bool?>(
          context: context,
          child: Container(
            height: 320,
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 12),
                    child: Text(
                      locale.getText('forgot_pin'),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: ColorNode.Dark3,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    locale.getText('forgot_pin_hint'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: ColorNode.Dark3,
                    ),
                  ),
                ),
                Spacer(),
                RoundedButton(
                  title: 'logout',
                  onPressed: () => Navigator.pop(context, true),
                ),
                SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
              ],
            ),
          ),
        ) ??
        false;

    if (result) Navigator.pop(context, ProfileWidget.Auth);
  }
}
