import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';

const _smallCircleSize = 67.0;
const _smallCircleTopPosition = -35.0;
const _smallCircleRightPosition = 62.0;

const _bigCircleSize = 165.0;
const _bigCircleBottomPosition = -81.0;
const _bigCircleRightPosition = -34.0;

class NoAttachedCardsBanner extends StatelessWidget {
  final Function attachNewCard;

  const NoAttachedCardsBanner({
    Key? key,
    required this.attachNewCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => attachNewCard(),
      child: Container(
        padding: const EdgeInsets.only(left: 12),
        decoration: const BoxDecoration(
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
                decoration: const BoxDecoration(
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
                decoration: const BoxDecoration(
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
                        const SizedBox(height: 12),
                        Text(
                          locale.getText('lets_start'),
                          style: TextStylesX.headline
                              .copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          height: 45,
                          child: Text(
                            locale.getText('no_attached_cards_banner'),
                            style: TextStylesX.caption2
                                .copyWith(color: Colors.white),
                            maxLines: 2,
                          ),
                        ),
                        Material(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () => attachNewCard(),
                            child: Ink(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child: Text(
                                locale.getText('add_card'),
                                style: TextStylesX.caption2SemiBold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  SvgPicture.asset(Assets.noAttachedCards),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
