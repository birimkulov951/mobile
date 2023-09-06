import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/widgets/item_padding.dart';

class ReceiverCardNumber extends StatelessWidget {
  const ReceiverCardNumber({
    Key? key,
    required this.number,
  }) : super(key: key);

  final String number;

  @override
  Widget build(BuildContext context) {
    return ItemPadding(
        child: Row(
      children: [
        SvgPicture.asset(Assets.noNameCard),
        const SizedBox(width: 12),
        Text(
          number,
          style: TextStyles.textRegular,
        )
      ],
    ));
  }
}
