import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';
import 'package:paynet_uikit/paynet_uikit.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({
    required this.onFastPaymentTap,
    required this.onQRPaymentTap,
    required this.onRequisitePaymentTap,
    super.key,
  });

  final VoidCallback onFastPaymentTap;
  final VoidCallback onQRPaymentTap;
  final VoidCallback onRequisitePaymentTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: BackgroundColors.primary,
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _QuickActionWidget(
            text: 'qr_pay',
            iconWidget: IconContainer(
              size: 56.0,
              child: ActionIcons.scan.copyWith(
                color: IconAndOtherColors.constant,
              ),
            ),
            onTap: onQRPaymentTap,
          ),
          _QuickActionWidget(
            text: 'fast_pay',
            iconWidget: IconContainer(
              size: 56.0,
              color: ControlColors.primaryActive,
              child: SvgPicture.asset(Assets.icRocket),
            ),
            onTap: onFastPaymentTap,
          ),
          _QuickActionWidget(
            text: 'pay_by_requisites',
            iconWidget: IconContainer(
              size: 56.0,
              child: OperationIcons.file.copyWith(
                color: IconAndOtherColors.constant,
              ),
            ),
            onTap: onRequisitePaymentTap,
          )
        ],
      ),
    );
  }
}

class _QuickActionWidget extends StatelessWidget {
  const _QuickActionWidget({
    required this.iconWidget,
    required this.text,
    required this.onTap,
  });

  final Widget iconWidget;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: iconWidget,
          ),
          const SizedBox(height: 12.0),
          TextLocale(
            text,
            style: Typographies.caption2SemiBold,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
