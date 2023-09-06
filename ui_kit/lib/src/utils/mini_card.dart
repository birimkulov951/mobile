import 'package:flutter/material.dart';

class MiniCard extends StatelessWidget {
  final String lastFour;
  final Widget cardBrand;
  final Color backgroundColor;

  const MiniCard({
    Key? key,
    required this.lastFour,
    required this.cardBrand,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 56,
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.5, horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lastFour,
                  style: TextStyle(fontSize: 9, color: Colors.white),
                ),
                Spacer(),
                cardBrand,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
