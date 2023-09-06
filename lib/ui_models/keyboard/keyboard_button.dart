import 'package:flutter/material.dart';

Widget buttonKey(
        String numb, Function(String) onPressed, BuildContext context) =>
    Container(
      width: 64,
      height: 64,
      decoration: ShapeDecoration(shape: CircleBorder()),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(64)),
        child: Center(
          child: Text(
            numb,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        onTap: () => onPressed(numb),
      ),
    );

Widget buttonKeyIcon(Widget icon, Function onPressed) => Container(
      width: 64,
      height: 64,
      decoration: ShapeDecoration(shape: CircleBorder()),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(64)),
        child: Center(child: icon),
        onTap: () => onPressed(),
      ),
    );
