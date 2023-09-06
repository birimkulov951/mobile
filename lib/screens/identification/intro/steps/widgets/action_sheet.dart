import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/main.dart' show locale;

class ActionSheet {
  /// TODO Название общее, а использование специфическое - переписать
  static void showActionSheet({
    required BuildContext context,
    required String title,
    required String subtitle,
    required VoidCallback scanPassport,
    required VoidCallback scanId,
  }) {
    if (Platform.isAndroid) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(24),
          ),
        ),
        builder: (context) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(24),
            ),
            child: Material(
              color: ColorNode.ContainerColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: ColorNode.Dark1,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: ColorNode.MainSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: ColorNode.Background,
                  ),
                  InkWell(
                    onTap: scanPassport,
                    child: Ink(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        locale.getText('passport_scan'),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ColorNode.Dark1,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: ColorNode.Background,
                  ),
                  InkWell(
                    onTap: scanId,
                    child: Ink(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      child: Text(
                        locale.getText('id_scan'),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ColorNode.Dark1,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: ColorNode.Background,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Ink(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        locale.getText('cancel'),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ColorNode.Dark1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: ColorNode.Dark1,
                ),
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: ColorNode.MainSecondary,
                ),
              ),
            ],
          ),
          actions: [
            CupertinoActionSheetAction(
              onPressed: scanPassport,
              child: Text(
                locale.getText('passport_scan'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: ColorNode.Dark1,
                ),
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: scanId,
              child: Text(
                locale.getText('id_scan'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: ColorNode.Dark1,
                ),
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              locale.getText('cancel'),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: ColorNode.Link,
              ),
            ),
          ),
        ),
      );
    }
  }
}
