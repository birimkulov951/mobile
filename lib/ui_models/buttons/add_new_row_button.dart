import 'package:flutter/material.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';

import 'package:mobile_ultra/ui_models/various/shape_circle.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

class AddNewRowButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final EdgeInsets padding;

  AddNewRowButton({
    required this.title,
    required this.onTap,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: RoundedButton(
        margin: const EdgeInsets.all(16),
        bg: Colors.transparent,
        icon: CircleShape(
          size: 40,
          color: ColorNode.itemBg,
          child: Icon(Icons.add),
        ),
        child: Text(
          title,
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.w500, letterSpacing: -.4),
        ),
        onPressed: onTap,
      ),
    );
  }
}
