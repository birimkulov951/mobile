import 'package:flutter/material.dart';

import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/main/home/widgets/my_accounts/widgets/row_stacked_icons.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

class MyAccountsEmptyWidget extends StatelessWidget {
  final VoidCallback onAccountAddTap;

  const MyAccountsEmptyWidget({
    required this.onAccountAddTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAccountAddTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: ColorNode.ContainerColor,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextLocale(
              'my_accounts',
              style: TextStyles.headline,
            ),
            const SizedBox(height: 4),
            TextLocale(
              'monitor_accounts',
              style: TextStyles.caption1MainSecondary,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    elevation: 0,
                    primary: ColorNode.Green,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                  onPressed: onAccountAddTap,
                  child: TextLocale(
                    'add_account',
                    style: TextStyles.caption2SemiBold
                        .copyWith(color: ColorNode.ContainerColor),
                  ),
                ),
                const Expanded(
                  child: RowStackedIcons(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
