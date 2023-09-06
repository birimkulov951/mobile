import 'package:flutter/material.dart';

import 'package:mobile_ultra/ui_models/keyboard/keyboard_button.dart';

class KeyboardNumbers extends StatelessWidget {
  final Function(String) onKeyPressed;
  final Function onRemove;
  final Widget bioIcon;
  final Function onBioAuth;

  KeyboardNumbers({
    required this.onKeyPressed,
    required this.onRemove,
    required this.bioIcon,
    required this.onBioAuth,
  });

  @override
  Widget build(BuildContext context) => Container(
          //margin: const EdgeInsets.only(left: 60, right: 60),
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buttonKey('1', onKeyPressed, context),
              const SizedBox(
                width: 24,
              ),
              buttonKey('2', onKeyPressed, context),
              const SizedBox(
                width: 24,
              ),
              buttonKey('3', onKeyPressed, context),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buttonKey('4', onKeyPressed, context),
              const SizedBox(
                width: 24,
              ),
              buttonKey('5', onKeyPressed, context),
              const SizedBox(
                width: 24,
              ),
              buttonKey('6', onKeyPressed, context),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buttonKey('7', onKeyPressed, context),
              const SizedBox(
                width: 24,
              ),
              buttonKey('8', onKeyPressed, context),
              const SizedBox(
                width: 24,
              ),
              buttonKey('9', onKeyPressed, context),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buttonKeyIcon(bioIcon, onBioAuth),
              const SizedBox(
                width: 24,
              ),
              buttonKey('0', onKeyPressed, context),
              const SizedBox(
                width: 24,
              ),
              buttonKeyIcon(Icon(Icons.backspace), onRemove),
            ],
          ),
        ],
      ));
}
