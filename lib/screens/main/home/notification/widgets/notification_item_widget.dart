import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ultra/domain/notification/notification_entity.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:paynet_uikit/paynet_uikit.dart';

class NotificationItemWidget extends StatelessWidget {
  const NotificationItemWidget({
    required this.onTap,
    required this.model,
    super.key,
  });

  final VoidCallback onTap;
  final NotificationEntity model;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(model.title, style: Typographies.textMedium),
                    const SizedBox(height: 4),
                    Text(
                      dateParse(model.date),
                      style: Typographies.caption2Secondary,
                    ),
                  ],
                ),
              ),
              if (model.date.split("T").first ==
                  DateFormat("yyyy-MM-dd").format(DateTime.now()))
                Ink(
                  decoration: const BoxDecoration(
                    color: ColorNode.Green,
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  ),
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    locale.getText("new"),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
