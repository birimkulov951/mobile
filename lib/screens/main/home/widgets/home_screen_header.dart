import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class HomeScreenHeader extends StatelessWidget {
  const HomeScreenHeader({
    required this.phoneNumber,
    required this.onProfileTap,
    required this.onSupportTap,
    required this.onNotificationTap,
    super.key,
  });

  final String phoneNumber;
  final VoidCallback onProfileTap;
  final VoidCallback onSupportTap;
  final VoidCallback onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onProfileTap,
            child: Row(
              children: [
                Container(
                  width: 32.0,
                  height: 32.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: IconAndOtherColors.accent,
                  ),
                ),
                const SizedBox(width: 12.0),
                Text(
                  phoneNumber,
                  style: Typographies.textMedium,
                ),
                ActionIcons.chevronRight16
                    .copyWith(color: IconAndOtherColors.secondary),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: onSupportTap,
          constraints: BoxConstraints.tight(
            const Size.square(32),
          ),
          padding: EdgeInsets.zero,
          icon: OperationIcons.support,
        ),
        const SizedBox(width: 8.0),
        IconButton(
          onPressed: onNotificationTap,
          constraints: BoxConstraints.tight(
            const Size.square(32),
          ),
          padding: EdgeInsets.zero,
          icon: OperationIcons.bell,
        ),
      ],
    );
  }
}
