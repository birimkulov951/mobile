import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/buttons/vertical_icon_button.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';

class TransferAbroadResultSuccess extends StatelessWidget {
  final String amountPaid;
  final String commission;
  final VoidCallback onTransferDetailsButtonTap;
  final VoidCallback onRepeatCurrentTransferTap;
  final VoidCallback onReturnToMain;

  const TransferAbroadResultSuccess({
    Key? key,
    required this.amountPaid,
    required this.commission,
    required this.onTransferDetailsButtonTap,
    required this.onRepeatCurrentTransferTap,
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
                top: 120,
                bottom: 24,
              ),
              child: SvgPicture.asset(Assets.success),
            ),
            Text(
              locale.getText('transfer_sent'),
              style: TextStyles.title5,
            ),
            SizedBox(height: 12),
            Text(
              amountPaid,
              style: TextStyles.title1,
            ),
            SizedBox(height: 4),
            Text(
              commission,
              style: TextStyles.caption1MainSecondary,
            ),
            const Spacer(),
            ItemContainer(
              backgroundColor: ColorNode.Background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              child: Column(
                children: [
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VerticalIconButton(
                        key: const Key(WidgetIds.transferAbroadRepeatTransfer),
                        textColor: Colors.black,
                        title: locale.getText('repeat_translation'),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: SvgPicture.asset(
                            Assets.repeat,
                            color: Colors.white,
                          ),
                        ),
                        onTap: onRepeatCurrentTransferTap,
                      ),
                      SizedBox(width: 36),
                      VerticalIconButton(
                        key: const Key(WidgetIds.transferAbroadSuccessTransferDetails),
                        textColor: Colors.black,
                        title: locale.getText('payment_details'),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: SvgPicture.asset(
                            Assets.cheque,
                            color: Colors.white,
                          ),
                        ),
                        onTap: onTransferDetailsButtonTap,
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  RoundedButton(
                    key: const Key(WidgetIds.transferAbroadSuccess),
                    onPressed: onReturnToMain,
                    title: locale.getText('done'),
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
