import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/registration/phone_number_login/phone_number_login_screen_wm.dart';
import 'package:mobile_ultra/screens/registration/phone_number_login/route/phone_number_login_screen_arguments.dart';
import 'package:mobile_ultra/ui_models/app_bar/custom_app_bar.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:ui_kit/ui_kit.dart';

class PhoneNumberLoginScreen
    extends ElementaryWidget<IPhoneNumberLoginScreenWidgetModel> {
  const PhoneNumberLoginScreen({
    Key? key,
    required this.arguments,
  }) : super(phoneNumberLoginScreenWidgetModelFactory, key: key);

  final PhoneNumberLoginScreenArguments arguments;

  @override
  Widget build(IPhoneNumberLoginScreenWidgetModel wm) => Stack(
        children: [
          Scaffold(
            appBar: PaynetAppBar(
              '',
              leading: wm.leading,
              backgroundColor: ColorNode.ContainerColor,
            ),
            body: Column(
              children: [
                ItemContainer(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        locale.getText('input_phone_number'),
                        style: TextStyles.title2,
                      ),
                      SizedBox(height: 28),
                      Text(
                        locale.getText('input_phone_number_hint'),
                        style: TextStyles.textRegular,
                      ),
                      SizedBox(height: 24),
                      PhoneInput(
                        controller: wm.phoneController,
                        focusNode: wm.focusNode,
                        inputFocusedStyle: TextStyles.textInputBold,
                        inputUnfocusedStyle: TextStyles.textInputBold,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                ValueListenableBuilder(
                  valueListenable: wm.isLoading,
                  builder: (_, bool isLoading, __) => ValueListenableBuilder(
                    valueListenable: wm.isContinueEnabled,
                    builder: (_, bool isEnabled, __) => RoundedButton(
                      title: 'continue',
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      loading: isLoading,
                      onPressed: isEnabled ? wm.fetchLoginOtp : null,
                    ),
                  ),
                ),
                SizedBox(height: wm.bottomPadding),
              ],
            ),
          ),
          ValueListenableBuilder(
            valueListenable: wm.isLoading,
            builder: (_, bool isLoading, __) => LoadingWidget(
              showLoading: isLoading,
            ),
          ),
        ],
      );
}
