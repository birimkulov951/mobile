import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/fast_payment_screen/fast_payment_screen_route.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';

final _smallCircleSize = 67.0;
final _smallCircleTopPosition = -35.0;
final _smallCircleRightPosition = 62.0;

final _bigCircleSize = 165.0;
final _bigCircleBottomPosition = -81.0;
final _bigCircleRightPosition = -34.0;

class FastPayBanner extends StatelessWidget {
  final VoidCallback onGoHistory;

  const FastPayBanner({
    Key? key,
    required this.onGoHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _checkIfOpenHistoryPage(context),
      child: Container(
        padding: EdgeInsets.only(left: 12),
        margin: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: ColorNode.Green,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              child: Container(
                height: _smallCircleSize,
                width: _smallCircleSize,
                decoration: BoxDecoration(
                  color: ColorNode.darkGreen,
                  borderRadius: BorderRadius.all(Radius.circular(67)),
                ),
              ),
              top: _smallCircleTopPosition,
              right: _smallCircleRightPosition,
            ),
            Positioned(
              child: Container(
                height: _bigCircleSize,
                width: _bigCircleSize,
                decoration: BoxDecoration(
                  color: ColorNode.darkGreen,
                  borderRadius: BorderRadius.all(Radius.circular(165)),
                ),
              ),
              bottom: _bigCircleBottomPosition,
              right: _bigCircleRightPosition,
            ),
            LocaleBuilder(
              builder: (_, locale) => Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 12),
                        Text(
                          locale.getText('fast_pay'),
                          style:
                              TextStyles.headline.copyWith(color: Colors.white),
                        ),
                        SizedBox(height: 4),
                        SizedBox(
                          height: 45,
                          child: Text(
                            locale.getText('fast_pay_banner_text'),
                            style: TextStyles.caption2
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        Material(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () => _checkIfOpenHistoryPage(context),
                            child: Ink(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child: Text(
                                locale.getText('forward'),
                                style: TextStyles.caption2SemiBold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                      ],
                    ),
                  ),
                  SvgPicture.asset(Assets.rocket),
                  SizedBox(width: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkIfOpenHistoryPage(BuildContext context) async {
    final openHistoryPage =
        await Navigator.of(context).pushNamed(FastPaymentScreenRoute.Tag);
    if (openHistoryPage == true) {
      onGoHistory();
    }
  }
}
