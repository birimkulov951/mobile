import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:paynet_uikit/paynet_uikit.dart';

class MiniCardWidget extends StatelessWidget {
  final AttachedCard? uCard;

  const MiniCardWidget({required this.uCard});

  @override
  Widget build(BuildContext context) => Container(
        width: 56,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: ColorUtils.colorSelect[uCard?.color],
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.5, horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    uCard?.number
                            ?.substring((uCard?.number?.length ?? 4) - 4) ??
                        '',
                    style: TextStyle(fontSize: 9, color: Colors.white),
                  ),
                  Spacer(),
                  cardTypeLogo,
                ],
              ),
            ),
            Container(
              width: 56,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  gradient: RadialGradient(
                    center: Alignment(-1, -.8),
                    radius: 3.2,
                    colors: <Color>[
                      Colors.white.withOpacity(.4),
                      Colors.transparent,
                    ],
                    stops: <double>[.4, .4],
                  )),
            ),
          ],
        ),
      );

  Widget get cardTypeLogo {
    switch (uCard?.type) {
      case Const.BONUS:
        return SvgPicture.asset(
          'assets/graphics/dark/paynet.svg',
          height: 7,
        );
      default:
        return Image.asset(
          'assets/image/ic_${uCard?.type == Const.UZCARD ? 'uzcard' : 'humo'}.png',
          height: 5,
        );
    }
  }
}
