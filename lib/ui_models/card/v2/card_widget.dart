import 'package:flutter/material.dart';

import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:ui_kit/ui_kit.dart' as uikit;

class CardWidget extends StatelessWidget {
  final AttachedCard uCard;
  final int? newColorIndex;

  const CardWidget({
    required this.uCard,
    this.newColorIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width - 32;

    return Container(
      width: size,
      height: size * .6,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        color: uikit.ColorUtils.colorSelect[newColorIndex ?? uCard.color],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    top: 16,
                    right: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        uCard.name ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      Image.asset(
                        'assets/image/ic_${uCard.type == Const.UZCARD ? 'uzcard' : 'humo'}.png',
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '${formatAmount(uCard.balance ?? 0)} ${locale.getText('sum')}',
                    softWrap: true,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatCardNumber(uCard.number ?? ''),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        formatExpDate(uCard.expDate) ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: size,
            height: size * 6,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-.58, -.5), // near the top right
                radius: 2.2,
                colors: <Color>[
                  Colors.white.withOpacity(.1), // yellow sun
                  Colors.transparent, // blue sky
                ],
                stops: const <double>[.4, .4],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
