import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';

extension SvgPictureExt on SvgPicture {
  SvgPicture copyWith({
    Color? color,
    double? width,
    final double? height,
  }) {
    final colorFilter =
        color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null;
    return SvgPicture(
      this.pictureProvider,
      colorFilter: colorFilter ?? this.colorFilter,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }
}
