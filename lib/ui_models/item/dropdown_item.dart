import 'package:flutter/material.dart';

class DropdownItem<T> extends StatelessWidget {
  final Widget child;
  final T value;
  final ValueChanged<T> onPressed;

  DropdownItem({
    Key? key,
    required this.child,
    required this.value,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        child: child,
        onTap: () => onPressed(value),
      );
}
