import 'package:flutter/material.dart';

import 'package:mobile_ultra/ui_models/various/shape_circle.dart';
import 'package:ui_kit/ui_kit.dart' as uikit;

class SubcategoryItem extends StatelessWidget {
  const SubcategoryItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onPressed,
    this.categoryId = const [],
    this.excludeId = const [],
  });

  final Widget icon;
  final List<int> categoryId;
  final List<int> excludeId;
  final String title;
  final Function(String, List<int>, List<int>) onPressed;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => onPressed(title, categoryId, excludeId),
        child: uikit.TitleCell.Chevron(
          title: title,
          icon: CircleShape(
            child: icon,
          ),
        ),
      );
}
