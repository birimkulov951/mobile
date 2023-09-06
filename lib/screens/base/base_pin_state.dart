import 'package:flutter/material.dart';

import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';
import 'package:mobile_ultra/ui_models/keyboard/keyboard_numbers.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

abstract class BasePinState<T extends StatefulWidget>
    extends BaseInheritedTheme<T> {
  bool showLoading = false;
  bool pause = false;

  var pinCode = ['', '', '', ''];
  Color indColor = ColorNode.Green;

  Widget get headerWidget;

  Widget get additionWidget;

  @override
  Widget get formWidget =>
      WillPopScope(child: layoutWidget, onWillPop: onBackPressed);

  Widget get layoutWidget => Stack(children: [
        Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  headerWidget,
                  const Spacer(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        4,
                        (index) => Container(
                          width: 48,
                          height: 60,
                          margin: const EdgeInsets.only(left: 4, right: 4),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              color: ColorNode.Main),
                          child: Center(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: ShapeDecoration(
                                  color: pinCode[index].isNotEmpty
                                      ? indColor
                                      : ColorNode.Main,
                                  shape: CircleBorder()),
                            ),
                          ),
                        ),
                      )),
                  KeyboardNumbers(
                    bioIcon: additionWidget,
                    onBioAuth: onAdditionWidgetPressed,
                    onKeyPressed: onKeyPressed,
                    onRemove: onRemoveKey,
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            )),
        LoadingWidget(
          showLoading: showLoading,
          withProgress: true,
        ),
      ]);

  Future<bool> onBackPressed();

  void onAdditionWidgetPressed();

  void onPinEntered(String pin);

  void onKeyPressed(String value) {
    if (pause) return;

    indColor = ColorNode.Green;

    final ind = pinCode.indexWhere((i) => i.isEmpty);
    if (ind != -1) setState(() => pinCode[ind] = value);

    if (pinCode.last.isNotEmpty) {
      pause = true;

      String pin = '';
      pinCode.forEach((value) => pin += value);

      onPinEntered(pin);
    }
  }

  void onErrorPin() => setState(() {
        pause = false;
        indColor = ColorNode.Red;
      });

  void onRemoveKey() {
    pause = false;

    final ind = pinCode.lastIndexWhere((i) => i.isNotEmpty);
    if (ind != -1) {
      setState(() => pinCode[ind] = '');
    }
  }

  void onFail(String error) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => showMessage(
            context, locale.getText('error'), error,
            onSuccess: () => Navigator.pop(context)),
      );

  void clearPin() => setState(() {
        pause = false;
        pinCode.replaceRange(0, pinCode.length, ['', '', '', '']);
      });
}
