import 'package:flutter/painting.dart';

class Gradients {
  Gradients._();

  static const shimmerGradient = LinearGradient(
    colors: [
      Color(0xFFEBEBF4),
      Color(0xFFEBEBF4),
      Color(0xFFF4F4F4),
      Color(0xFFEBEBF4),
      Color(0xFFEBEBF4),
    ],
    stops: [0.0, 0.35, 0.5, 0.65, 1.0],
    begin: Alignment(-1.0, -0.2),
    end: Alignment(1.0, 0.2),
    tileMode: TileMode.clamp,
  );

  static const shimmerGradientLight = const LinearGradient(
    colors: [
      Color(0xFFF9F9F9),
      Color(0xFFF9F9F9),
      Color(0xFFFFFFFF),
      Color(0xFFF9F9F9),
      Color(0xFFF9F9F9),
    ],
    stops: [
      0.0,
      0.35,
      0.5,
      0.65,
      1.0,
    ],
    begin: Alignment(-1.0, -0.2),
    end: Alignment(1.0, 0.2),
    tileMode: TileMode.clamp,
  );

  static const placeholderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFEDEFF1),
      Color(0xFFF9F9F9),
    ],
    stops: [0.0, 1.0],
  );

  static const placeholderGradientGreen = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF17A53C),
      Color(0xFFB9E4C5),
    ],
    stops: [0.0, 1.0],
  );
}
