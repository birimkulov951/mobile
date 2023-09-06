import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';

const _maxLengthOfTextFieldContent = 200;

class NegativeFeedback extends StatelessWidget {
  const NegativeFeedback({
    Key? key,
    required this.isNegativeFeedbackLoadingState,
    required this.isFeedbackFieldEmptyState,
    required this.hideKeyboard,
    required this.onTapCleanFeedbackField,
    required this.onPressSendFeedback,
    required this.feedbackFieldController,
  }) : super(key: key);

  final StateNotifier<bool> isNegativeFeedbackLoadingState;
  final StateNotifier<bool> isFeedbackFieldEmptyState;
  final VoidCallback hideKeyboard;
  final VoidCallback onTapCleanFeedbackField;
  final VoidCallback onPressSendFeedback;
  final TextEditingController feedbackFieldController;

  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder(
      listenableState: isNegativeFeedbackLoadingState,
      builder: (_, isLoading) => Opacity(
        opacity: isLoading == true ? 0.5 : 1,
        child: AbsorbPointer(
          absorbing: isLoading == true,
          child: GestureDetector(
            onTap: hideKeyboard,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
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
                      locale.getText('any_obstacles'),
                      style: TextStyles.title5,
                    ),
                    SizedBox(height: 12),
                    Text(
                      locale.getText('tell_problems'),
                      style: TextStyles.textRegular,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 24),
                    StateNotifierBuilder(
                        listenableState: isFeedbackFieldEmptyState,
                        builder: (_, _isEmpty) {
                          return LocaleBuilder(
                            builder: (_context, locale) => Container(
                              height: 58,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: ColorNode.Main,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                              child: TextField(
                                controller: feedbackFieldController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  floatingLabelStyle:
                                      TextStyles.caption1MainSecondary,
                                  labelText: locale.getText('what_to_improve'),
                                  labelStyle: TextStyles.textRegularSecondary,
                                  suffixIcon: IconButton(
                                    splashRadius: 1,
                                    icon: _isEmpty == true
                                        ? const SizedBox.shrink()
                                        : SvgPicture.asset(Assets.clear),
                                    onPressed: onTapCleanFeedbackField,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  counterText: '',
                                ),
                                maxLength: _maxLengthOfTextFieldContent,
                                cursorColor: ColorNode.Green,
                              ),
                            ),
                          );
                        }),
                    SizedBox(height: 40),
                    StateNotifierBuilder(
                      listenableState: isFeedbackFieldEmptyState,
                      builder: (_, _isEmpty) => LocaleBuilder(
                        builder: (_, locale) => RoundedButton(
                          title: locale.getText('send'),
                          loading: isLoading == true,
                          onPressed:
                              _isEmpty == true ? null : onPressSendFeedback,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Builder(
                      builder: (context) => SizedBox(
                        height: MediaQuery.of(context).viewPadding.bottom +
                            MediaQuery.of(context).viewInsets.bottom,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
