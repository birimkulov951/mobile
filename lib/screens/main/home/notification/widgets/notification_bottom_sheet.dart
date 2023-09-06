import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ultra/domain/notification/notification_entity.dart';
import 'package:mobile_ultra/resource/dimensions.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/ui_models/modal_bottom_sheet/custom_modal_bottom_sheet.dart';
import 'package:ui_kit/ui_kit.dart';

class NotificationBottomSheet extends StatelessWidget {
  const NotificationBottomSheet({
    required this.data,
    super.key,
  });

  final NotificationEntity data;

  static Future<void> show(
    BuildContext context, {
    required NotificationEntity data,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.unit3),
        ),
      ),
      builder: (BuildContext context) {
        return NotificationBottomSheet(
          data: data,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomModalBottomSheet(
      title: data.title,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16),
              child: Text(
                DateFormat("dd.MM.yyyy, HH:mm").format(
                  DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(data.date),
                ),
                style: Typographies.caption1Secondary,
              ),
            ),
            Html(
              style: {
                "html": Style.fromTextStyle(
                  TextStyles.textRegular,
                )..padding = const EdgeInsets.symmetric(horizontal: 8),
              },
              data: data.message,
            ),
          ],
        ),
      ),
    );
  }
}
