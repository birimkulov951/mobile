import 'package:flutter/material.dart';
import 'package:mobile_ultra/resource/dimensions.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/modal_bottom_sheet/custom_modal_bottom_sheet.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

class AlertBottomSheet extends StatelessWidget {
  const AlertBottomSheet({
    Key? key,
    required this.title,
    required this.bodyText,
    required this.buttonText,
    required this.maxPercentageHeight,
  }) : super(key: key);

  final String title;
  final String bodyText;
  final String buttonText;
  final double maxPercentageHeight;

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String bodyText,
    required String buttonText,
    double maxPercentageHeight = 0.9,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.only(
          topLeft: const Radius.circular(Dimensions.unit3),
          topRight: const Radius.circular(Dimensions.unit3),
        ),
      ),
      builder: (context) => AlertBottomSheet(
        title: title,
        bodyText: bodyText,
        buttonText: buttonText,
        maxPercentageHeight: maxPercentageHeight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomModalBottomSheet(
      title: title,
      maxPercentageHeight: maxPercentageHeight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 12,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: 190),
              child: TextLocale(
                bodyText,
                style: TextStyles.textRegular,
              ),
            ),
            const Spacer(),
            RoundedButton(
              title: buttonText,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
