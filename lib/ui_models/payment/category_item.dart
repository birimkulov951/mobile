import 'package:flutter/material.dart';

import 'package:mobile_ultra/ui_models/various/shape_circle.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

import 'package:paynet_uikit/paynet_uikit.dart' as uikit;

class CategoryItem extends StatefulWidget {
  const CategoryItem({
    Key? key,
    required this.icon,
    required this.title,
    this.categoryIds = const [],
    this.children = const [],
    this.onPressed,
    this.onExpanded,
  });

  final Widget icon;
  final List<int> categoryIds;
  final String title;
  final List<Widget> children;
  final Function(String, List<int>, List<int>)? onPressed;
  final Function(bool)? onExpanded;

  @override
  State<StatefulWidget> createState() => CategoryItemState();
}

class CategoryItemState extends State<CategoryItem>
    with TickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
    reverseDuration: const Duration(milliseconds: 250),
    lowerBound: 0,
    upperBound: 1.5,
  );

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: ColorNode.Dark1),
        ),
        child: ExpansionTile(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleShape(
                child: widget.icon,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.title,
                  style: uikit.Typographies.textRegular,
                ),
              )
            ],
          ),
          childrenPadding: EdgeInsets.zero,
          onExpansionChanged: (value) {
            if (widget.onPressed == null) {
              widget.onExpanded?.call(value);

              if (value) {
                _animationController.forward();
              } else {
                _animationController.reverse();
              }
            } else {
              widget.onPressed?.call(widget.title, widget.categoryIds, []);
            }
          },
          trailing: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) => Transform.rotate(
              angle: _animationController.value * -1,
              child: child,
            ),
            child: uikit.ActionIcons.chevronRight16,
          ),
          children: children,
        ),
      );

  List<Widget> get children => [
        ColoredBox(
          color: ColorNode.Background,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.children,
          ),
        )
      ];
}
