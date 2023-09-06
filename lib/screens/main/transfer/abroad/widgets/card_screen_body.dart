import 'package:flutter/material.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

class CardScreenBody extends StatelessWidget {
  const CardScreenBody({Key? key, required this.child}) : super(key: key);

  final Widget child;

  Decoration get _containerDecoration {
    return const BoxDecoration(
      color: ColorNode.ContainerColor,
      borderRadius: const BorderRadius.only(
        topLeft: const Radius.circular(24),
        topRight: const Radius.circular(24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: _containerDecoration,
      child: child,
    );
  }
}
