import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  final double right;
  final double bottom;
  final Function({int? checkTo})? onPress;

  const NextButton({
    Key? key,
    this.right = 0,
    this.bottom = 0,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Positioned(
        right: right,
        bottom: bottom,
        child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: onPress == null ? Colors.grey : Colors.green,
              boxShadow: [
                BoxShadow(
                    offset: Offset(2, 2),
                    color: onPress == null
                        ? Colors.grey.withOpacity(.8)
                        : Colors.green.withOpacity(.8),
                    blurRadius: 10)
              ]),
          child: IconButton(
            icon: Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
            onPressed: onPress,
          ),
        ),
      );
}
