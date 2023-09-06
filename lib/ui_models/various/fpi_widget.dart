import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:mobile_ultra/domain/favorite/favorite.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/ui_models/various/circle_image.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/u.dart';

enum FPIType {
  TRANSFER,
  MERCHANT,
}

class FPIWidget extends StatefulWidget {
  const FPIWidget({
    required this.item,
    required this.onTap,
    super.key,
  });

  final FavoriteEntity item;
  final ValueChanged<FavoriteEntity> onTap;

  @override
  State<StatefulWidget> createState() => FPIWidgetState();
}

class FPIWidgetState extends State<FPIWidget> {
  @override
  Widget build(BuildContext context) => SizedBox(
        width: 76,
        child: InkWell(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: widget.item.type == FPIType.TRANSFER
                      ? ColorNode.accent
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Builder(
                  builder: (context) {
                    switch (widget.item.type) {
                      case FPIType.TRANSFER:
                        return Center(
                          child: SvgPicture.asset(
                            Assets.transfer,
                            width: 24,
                            height: 24,
                            color: ColorNode.ContainerColor,
                          ),
                        );
                      default:
                        return CircleImage(
                          merchantId: widget.item.merchantData?.merchantId,
                        );
                    }
                  },
                ),
              ),
              SizedBox(height: 12),
              Text(
                favoriteTemplateName(widget.item),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.caption2SemiBold,
              ),
            ],
          ),
          onTap: () => widget.onTap(widget.item),
        ),
      );
}
