import 'package:flutter/painting.dart';

import 'package:mobile_ultra/resource/gradients.dart';

class Decorations {
  Decorations._();

  static const gradientedDecoration = BoxDecoration(
    gradient: Gradients.placeholderGradient,
    borderRadius: BorderRadius.all(
      Radius.circular(8),
    ),
  );

  static final gradientedDecorationSmall = gradientedDecoration.copyWith(
    borderRadius: const BorderRadius.all(
      Radius.circular(4),
    ),
  );

  static const gradientedCircularDecoration = BoxDecoration(
    gradient: Gradients.placeholderGradient,
    shape: BoxShape.circle,
  );
}
