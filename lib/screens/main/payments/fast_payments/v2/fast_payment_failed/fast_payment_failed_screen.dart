import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/main/navigation.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/fast_payment_failed/route/arguments.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/fast_payment_screen/fast_payment_screen_route.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

class FastPaymentFailedScreen extends StatelessWidget {
  final FastPaymentFailedScreenArguments arguments;

  const FastPaymentFailedScreen({
    required this.arguments,
    super.key,
  });

  void _back(BuildContext context) {
    Navigator.of(context).popUntil((route) {
      final routeName = route.settings.name;
      return routeName == FastPaymentScreenRoute.Tag ||
          routeName == NavigationWidget.Tag;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorNode.ContainerColor,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Container(
                    height: 76,
                    width: 76,
                    margin: const EdgeInsets.only(
                      top: 160,
                      bottom: 24,
                    ),
                    child: SvgPicture.asset(Assets.fail),
                  ),
                  Text(
                    arguments.errorHeadline,
                    style: TextStyles.title5,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    arguments.errorText,
                    style: TextStyles.caption1MainSecondary,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Spacer(),
            ItemContainer(
              backgroundColor: ColorNode.Background,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  RoundedButton(
                    onPressed: () => _back(context),
                    title: locale.getText('good'),
                    margin: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 24,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
