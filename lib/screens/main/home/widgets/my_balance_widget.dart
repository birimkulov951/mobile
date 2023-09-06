import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/net/card/model/main_data.dart';
import 'package:mobile_ultra/screens/main/home/widgets/shimmer/my_balance_shimmer.dart';
import 'package:mobile_ultra/screens/qa/qa_page.dart';
import 'package:mobile_ultra/utils/app_config.dart';
import 'package:mobile_ultra/widgets/balance_widget.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';
import 'package:ui_kit/ui_kit.dart';

class MyBalanceWidget extends StatelessWidget {
  const MyBalanceWidget({
    required this.flipBalanceVisibility,
    required this.isBalanceHidden,
    required this.allCardsData,
    super.key,
  });

  final VoidCallback flipBalanceVisibility;
  final bool isBalanceHidden;
  final EntityStateNotifier<MainData> allCardsData;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (Config.appFlavor == Flavor.DEVELOPMENT) {
                Navigator.of(context).pushNamed(
                  QAPage.Tag,
                );
              }
            },
            child: TextLocale(
              'my_money',
              style: Typographies.caption1Secondary,
            ),
          ),
          const SizedBox(height: 8.0),
          EntityStateNotifierBuilder<MainData>(
            listenableEntityState: allCardsData,
            loadingBuilder: (_, __) => const MyBalanceShimmer(),
            builder: (_, MainData? data) {
              return Row(
                children: [
                  Expanded(
                    child: BalanceWidget.big(
                      amount: data?.totalBalance ?? 0,
                      hideBalance: isBalanceHidden,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  IconButton(
                    onPressed: flipBalanceVisibility,
                    constraints: BoxConstraints.tight(
                      const Size.square(32),
                    ),
                    padding: EdgeInsets.zero,
                    icon: isBalanceHidden
                        ? ActionIcons.eyeClose
                        : ActionIcons.eyeOpen,
                  ),
                ],
              );
            },
          ),
        ],
      );
}
