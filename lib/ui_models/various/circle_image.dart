import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/main.dart' show getAccessToken;
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/ui_models/various/svg_graphics.dart';
import 'package:mobile_ultra/utils/const.dart';

class CircleImage extends StatelessWidget {
  CircleImage({
    this.merchantId,
    this.size = 46,
  });

  final dynamic merchantId;
  final double size;

  @override
  Widget build(BuildContext context) => (merchantId == -1 || merchantId == '-1')
      ? SvGraphics.icon('info', size: size)
      : CachedNetworkImage(
          imageUrl: '${Http.URL}pms2/api/v2/merchant/logo/$merchantId',
          httpHeaders: {Const.AUTHORIZATION: getAccessToken()},
          width: size,
          height: size,
          fit: BoxFit.fill,
          errorWidget: (context, url, error) => SvGraphics.icon(
            'info',
            size: size,
          ),
        );
}
