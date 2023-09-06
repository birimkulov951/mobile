import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';

import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/buttons/button_border.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

class PositiveNegativeOption extends StatelessWidget {
  const PositiveNegativeOption({
    Key? key,
    required this.loadingState,
    required this.onPressAllGoodButton,
    required this.onPressSomethingWrongButton,
  }) : super(key: key);

  final StateNotifier<bool> loadingState;
  final VoidCallback onPressAllGoodButton;
  final VoidCallback onPressSomethingWrongButton;

  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder(
      listenableState: loadingState,
      builder: (context, isLoading) => Opacity(
        opacity: isLoading == true ? 0.5 : 1,
        child: AbsorbPointer(
          absorbing: isLoading == true,
          child: Container(
            width: double.infinity,
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
                  locale.getText('how_is_pynet'),
                  style: TextStyles.title5,
                ),
                SizedBox(height: 12),
                Text(
                  locale.getText('we_consider_feedbacks'),
                  style: TextStyles.textRegular,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 40),
                RoundedButton(
                  child: TextLocale(
                    'all_good',
                    style: TextStyles.caption1MediumWhite,
                  ),
                  loading: isLoading == true,
                  onPressed: onPressAllGoodButton,
                ),
                SizedBox(height: 12),
                LocaleBuilder(
                  builder: (_, locale) => RoundedButtonBorder(
                    title: locale.getText('something_is_wrong'),
                    onPressed: onPressSomethingWrongButton,
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
