import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

class CardSMSConfirmationDisabledWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/graphics_redesign/clear.svg',
                  height: 77,
                  color: ColorNode.Red,
                ),
                const SizedBox(height: 24),
                Text(
                  locale.getText('sms_confirmation_alert'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.4,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  locale.getText('sms_confirmation_alert_desc'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.4,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: ColorNode.MainSecondary),
                ),
              ],
            ),
          )),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ItemContainer(
              backgroundColor: ColorNode.Background,
              padding: EdgeInsets.fromLTRB(
                  16, 28, 16, MediaQuery.of(context).viewPadding.bottom + 16),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              child: RoundedButton(
                title: 'exit',
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
