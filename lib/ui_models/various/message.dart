import 'package:flutter/material.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';

import 'package:mobile_ultra/utils/color_scheme.dart';

Widget showMessage(
  BuildContext context,
  String title,
  String content, {
  String? dismissTitle,
  String successTitle = 'OK',
  VoidCallback? onDismiss,
  VoidCallback? onSuccess,
}) =>
    AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6))),
      content: Text(
        content,
        style: TextStyle(color: Colors.black),
      ),
      actions: <Widget>[
        if (dismissTitle != null)
          RoundedButton(
            child: Text(
              dismissTitle,
              style: TextStyle(color: Colors.black),
            ),
            onPressed: onDismiss,
            bg: Colors.transparent,
          ),
        RoundedButton(
          child: Text(
            successTitle,
            style: TextStyle(color: Colors.black),
          ),
          onPressed: onSuccess,
          bg: Colors.transparent,
        )
      ],
    );


Widget showProgressMessage(
        BuildContext context, String title, String message) =>
    AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: TextStyle(color: Colors.black),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6))),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CircularProgressIndicator(
              strokeWidth: 1.5,
              valueColor: AlwaysStoppedAnimation<Color>(ColorNode.Green),
            ),
            SizedBox(width: 10),
            Flexible(
              child: Text(
                message,
                style: TextStyle(color: Colors.black, letterSpacing: -.2),
              ),
            ),
          ],
        ));
