import 'package:flutter/material.dart';

import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/buttons/button_border.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

class PositiveFeedback extends StatelessWidget {
  const PositiveFeedback({
    Key? key,
    required this.onPressRateApp,
    required this.onPressNextTime,
  }) : super(key: key);

  final VoidCallback onPressRateApp;
  final VoidCallback onPressNextTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 6),
          Align(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: ColorNode.GreyScale400,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            locale.getText('thanks_for_opinion'),
            style: TextStyles.title5,
          ),
          SizedBox(height: 12),
          Text(
            locale.getText('rate_our_app'),
            style: TextStyles.textRegular,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 40),
          RoundedButton(
            child: TextLocale(
              'of_course',
              style: TextStyles.caption1MediumWhite,
            ),
            onPressed: onPressRateApp,
          ),
          SizedBox(height: 12),
          LocaleBuilder(
            builder: (_, locale) => RoundedButtonBorder(
              title: locale.getText('another_time'),
              onPressed: onPressNextTime,
            ),
          ),
          SizedBox(height: 16),
          Builder(
              builder: (context) =>
                  SizedBox(height: MediaQuery.of(context).viewPadding.bottom)),
        ],
      ),
    );
  }
}
