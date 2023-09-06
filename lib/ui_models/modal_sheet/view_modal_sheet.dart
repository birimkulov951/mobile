import 'package:flutter/material.dart';


import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

Future<T?> viewModalSheet<T>({
  required BuildContext context,
  required Widget child,
  Color backgroundColor = Colors.white,
  bool compact = false,
  BoxConstraints? boxConstraints,
}) async {
  return await showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: backgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24),
      ),
    ),
    builder: (_) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 4,
          margin: EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            color: ColorNode.GreyScale400,
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
          ),
        ),
        Container(
          constraints: boxConstraints ?? BoxConstraints(
            maxHeight: screenHeight - statusBarHeight - 10,
            minHeight: compact ? .0 : screenHeight / 2,
          ),
          child: child,
        ),
      ],
    ),
  );
}

