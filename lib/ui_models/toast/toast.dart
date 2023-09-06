import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:fluttertoast/fluttertoast.dart';

const _verticalPadding = 14.0;
const _horizontalPadding = 16.0;
const _horizontalMargin = 10.0;
const _iconSize = 24.0;

enum ToastType { success }

class Toast extends StatelessWidget {
  const Toast({
    Key? key,
    required this.title,
    required this.style,
    required this.type,
  }) : super(key: key);

  final String title;

  final TextStyle style;

  final ToastType type;

  static Function show(
    BuildContext context, {
    required String title,
    required ToastType type,
    hasTopPadding = true,
  }) {
    final toast = FToast();
    toast.init(context);

    final query = MediaQuery.of(context);

    toast.showToast(
        toastDuration: const Duration(seconds: 4),
        fadeDuration: const Duration(milliseconds: 250),
        positionedToastBuilder: (context, child) {
          return Positioned(
            top: hasTopPadding
                ? query.viewPadding.top + kToolbarHeight
                : query.viewPadding.top + 8,
            left: 0,
            right: 0,
            child: child,
          );
        },
        child: GestureDetector(
          onTap: toast.removeCustomToast,
          child: Toast(
            title: title,
            type: type,
            style: TextStyles.captionButton.copyWith(color: Colors.white),
          ),
        ));
    return toast.removeCustomToast;
  }

  String get _assetName {
    switch (type) {
      case ToastType.success:
        return Assets.successSmall;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: _verticalPadding,
        horizontal: _horizontalPadding,
      ),
      margin: const EdgeInsets.symmetric(horizontal: _horizontalMargin),
      decoration: BoxDecoration(
        color: ColorNode.Dark1,
        borderRadius: const BorderRadius.all(
          const Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            _assetName,
            width: _iconSize,
            height: _iconSize,
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
              child: Text(
            title,
            style: style,
          ))
        ],
      ),
    );
  }
}
