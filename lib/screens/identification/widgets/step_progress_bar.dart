import 'package:flutter/material.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

class StepProgressBar extends StatelessWidget {
  final Size screenSize;
  final int currentStep;

  const StepProgressBar({
    Key? key,
    required this.screenSize,
    required this.currentStep,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      color: ColorNode.ContainerColor,
      alignment: Alignment.centerLeft,
      child: Container(
        height: 4,
        width: currentStep == 1 ? screenSize.width / 2 : double.infinity,
        color: ColorNode.Green,
      ),
    );
  }
}
