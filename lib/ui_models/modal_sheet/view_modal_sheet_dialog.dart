import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/ui_models/various/title1.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:paynet_uikit/paynet_uikit.dart' as uiKit;

Future<bool?> viewModalSheetDialog({
  required BuildContext context,
  required String title,
  String? message,
  required String confirmBtnTitle,
  required String cancelBtnTitle,
  TextStyle? confirmBtnTextStyle,
  TextStyle? cancelBtnTextStyle,
}) async {
  return Platform.isAndroid
      ? await viewAndroidModalSheetDialog(
          context: context,
          title: title,
          message: message,
          confirmBtnTitle: confirmBtnTitle,
          cancelBtnTitle: cancelBtnTitle,
          confirmBtnTextStyle: confirmBtnTextStyle,
          cancelBtnTextStyle: cancelBtnTextStyle)
      : await viewIosModalSheetDialog(
          context: context,
          title: title,
          message: message,
          confirmBtnTitle: confirmBtnTitle,
          cancelBtnTitle: cancelBtnTitle,
          confirmBtnTextStyle: confirmBtnTextStyle,
          cancelBtnTextStyle: cancelBtnTextStyle,
        );
}

Future<bool?> viewAndroidModalSheetDialog({
  required BuildContext context,
  required String title,
  String? message,
  required String confirmBtnTitle,
  required String cancelBtnTitle,
  TextStyle? confirmBtnTextStyle,
  TextStyle? cancelBtnTextStyle,
}) async {
  return await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      margin: EdgeInsets.fromLTRB(
          8, 8, 8, MediaQuery.of(context).viewPadding.bottom + 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: uiKit.Typographies.title4,
            ),
          ),
          Visibility(
            visible: message != null,
            child: Title1(
              text: message ?? '',
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              size: 16,
              color: ColorNode.MainSecondary,
            ),
          ),
          Divider(
            height: 0,
            thickness: 1,
          ),
          RoundedButton(
            bg: Colors.transparent,
            height: 52,
            padding: EdgeInsets.only(left: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                confirmBtnTitle,
                style: confirmBtnTextStyle ??
                    TextStyles.textMedium.copyWith(height: 1),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
          ),
          Divider(
            height: 0,
            thickness: 1,
          ),
          RoundedButton(
            bg: Colors.transparent,
            height: 52,
            padding: EdgeInsets.only(left: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                cancelBtnTitle,
                style: cancelBtnTextStyle ??
                    TextStyles.textMedium.copyWith(height: 1),
              ),
            ),
            onPressed: () => Navigator.pop(context, false),
          )
        ],
      ),
    ),
  );
}

Future<bool?> viewIosModalSheetDialog({
  required BuildContext context,
  required String title,
  String? message,
  required String confirmBtnTitle,
  required String cancelBtnTitle,
  TextStyle? confirmBtnTextStyle,
  TextStyle? cancelBtnTextStyle,
}) async {
  return await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => Padding(
      padding: EdgeInsets.fromLTRB(
          8, 8, 8, MediaQuery.of(context).viewPadding.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ItemContainer(
            borderRadius: BorderRadius.all(Radius.circular(14)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Title1(
                  text: title,
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                  size: 17,
                  weight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ),
                if (message == null) SizedBox(height: 12),
                if (message != null)
                  Title1(
                    text: message,
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    size: 13,
                    color: ColorNode.MainSecondary,
                    textAlign: TextAlign.center,
                  ),
                const Divider(
                  height: .1,
                ),
                RoundedButton(
                  bg: Colors.transparent,
                  height: 56,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      confirmBtnTitle,
                      style: confirmBtnTextStyle ??
                          TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          ItemContainer(
              height: 56,
              borderRadius: BorderRadius.all(Radius.circular(14)),
              child: RoundedButton(
                bg: Colors.transparent,
                height: 56,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    cancelBtnTitle,
                    style: cancelBtnTextStyle ??
                        TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: ColorNode.Link,
                        ),
                  ),
                ),
                onPressed: () => Navigator.pop(context, false),
              )),
        ],
      ),
    ),
  );
}
