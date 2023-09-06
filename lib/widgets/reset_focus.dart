import 'package:flutter/material.dart';
import 'package:mobile_ultra/utils/focus_util.dart';

class ResetFocusWidget extends StatelessWidget {
  final Widget child;

  const ResetFocusWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => resetFocus(context),
      child: child,
    );
  }
}
