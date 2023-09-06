import 'package:flutter/material.dart';

import 'package:mobile_ultra/utils/color_scheme.dart';

class LoadingWidget extends StatelessWidget {
  final bool? showLoading;
  final String message;
  final double width, height;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final bool withProgress;
  late final Color background;

  LoadingWidget({
    this.showLoading,
    this.message = '',
    this.width = double.infinity,
    this.height = double.infinity,
    this.borderRadius = BorderRadius.zero,
    this.padding = const EdgeInsets.all(0),
    this.withProgress = false,
    Color? background,
  }) {
    this.background = background ?? Color(0xFFEAECF0).withOpacity(.5);
  }

  @override
  Widget build(BuildContext context) => Visibility(
        visible: showLoading ?? true,
        child: Container(
          width: width,
          height: height,
          margin: padding,
          decoration: BoxDecoration(
            color: background,
            borderRadius: borderRadius,
          ),
          child: Center(
            child: Visibility(
              visible: withProgress,
              child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(ColorNode.Green)),
            ),
          ),
        ),
      );
}
