import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/buttons/button_border.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

const _bottomSheetMaxHeightRatio = 0.6;

class EnableBiometricsBottomSheet extends StatelessWidget {
  const EnableBiometricsBottomSheet({
    Key? key,
    required this.enableBiometrics,
  }) : super(key: key);

  final VoidCallback enableBiometrics;

  static void show({
    required BuildContext context,
    required VoidCallback enableBiometrics,
    required VoidCallback setBiometricsEnablingAsked,
  }) =>
      viewModalSheet(
        context: context,
        boxConstraints: BoxConstraints(
          maxHeight:
              MediaQuery.of(context).size.height * _bottomSheetMaxHeightRatio,
        ),
        child: EnableBiometricsBottomSheet(enableBiometrics: enableBiometrics),
      ).then((_) => setBiometricsEnablingAsked());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextLocale(
            'turn_on_biometrics_title',
            style: TextStyles.title4,
          ),
          SizedBox(height: 12),
          TextLocale(
            'turn_on_biometrics_hint',
            style: TextStyles.textRegular,
          ),
          const Spacer(),
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(Assets.faceId),
          ),
          const Spacer(),
          RoundedButton(
            child: TextLocale(
              'turn_on',
              style: TextStyles.caption1MediumWhite,
            ),
            onPressed: () {
              enableBiometrics();
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 12),
          RoundedButtonBorder(
            title: 'another_time',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
        ],
      ),
    );
  }
}
