import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';

class TransferAbroadResultFail extends StatelessWidget {
  final VoidCallback onReturnToMain;

  const TransferAbroadResultFail({
    Key? key,
    required this.onReturnToMain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorNode.ContainerColor,
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 76,
              width: 76,
              margin: EdgeInsets.only(
                top: 160,
                bottom: 24,
              ),
              child: SvgPicture.asset(Assets.fail),
            ),
            Text(
              locale.getText('something_went_wrong'),
              style: TextStyles.title5,
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                locale.getText('cannot_transfer_abroad'),
                style: TextStyles.caption1MainSecondary,
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            ItemContainer(
              backgroundColor: ColorNode.Background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              child: Column(
                children: [
                  SizedBox(height: 24),
                  RoundedButton(
                    key: const Key(WidgetIds.transferAbroadFail),
                    onPressed: onReturnToMain,
                    title: locale.getText('go_back_to_the_main_page'),
                    margin: EdgeInsets.only(
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
