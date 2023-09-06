import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paynet_uikit/paynet_uikit.dart';

const _logoBalanceDistanceBig = 40.0;
const _balancePanDistanceBig = 30.0;

const _logoBalanceDistanceMedium = 34.34;
const _balancePanDistanceMedium = 25.23;

class BigCard extends StatelessWidget {
  final Color color;
  final String name;
  final SvgPicture logo;
  final String balance;
  final String maskedPan;
  final String? expDate;

  final double logoBalanceDistance;
  final double balancePanDistance;

  const BigCard.big({
    Key? key,
    required this.color,
    required this.name,
    required this.logo,
    required this.balance,
    required this.maskedPan,
    this.logoBalanceDistance = _logoBalanceDistanceBig,
    this.balancePanDistance = _balancePanDistanceBig,
    this.expDate,
  }) : super(key: key);

  const BigCard.medium({
    Key? key,
    required this.color,
    required this.name,
    required this.logo,
    required this.balance,
    required this.maskedPan,
    this.logoBalanceDistance = _logoBalanceDistanceMedium,
    this.balancePanDistance = _balancePanDistanceMedium,
    this.expDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Typographies.captionButtonConstant,
                  ),
                  logo
                ],
              ),
              SizedBox(height: logoBalanceDistance),
              Text(
                balance,
                style: Typographies.title2Constant,
              ),
              SizedBox(height: balancePanDistance),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    maskedPan,
                    style: Typographies.caption1Constant,
                  ),
                  if (expDate != null)
                    Text(
                      expDate!,
                      style: Typographies.caption1Constant,
                    )
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 198,
          decoration: BoxDecoration(
              gradient: RadialGradient(
            center: const Alignment(-.58, -.5),
            radius: 2.2,
            colors: <Color>[
              Colors.white.withOpacity(.1),
              Colors.transparent, // blue sky
            ],
            stops: const <double>[.4, .4],
          )),
        ),
      ],
    );
  }
}
