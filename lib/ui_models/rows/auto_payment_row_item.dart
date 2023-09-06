import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';
import 'package:sprintf/sprintf.dart';

import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/net/payment/model/reminder.dart';
import 'package:mobile_ultra/ui_models/various/circle_image.dart';
import 'package:mobile_ultra/ui_models/various/label.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/u.dart';

class AutoPaymentRowItem extends StatelessWidget {
  final dateFormat = DateFormat("dd.MM.yyyy");
  final Reminder reminder;
  final Function(Reminder)? onTap;
  final VoidCallback? onReschedule;

  AutoPaymentRowItem({
    required this.reminder,
    required this.onTap,
    this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    DateTime leftDays =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    DateTime date = DateFormat("yyyy-MM-ddTHH:mm:ss")
        .parse(reminder.finishDate ?? '', true);
    date = DateTime(date.year, date.month, date.day);

    return Container(
      width: MediaQuery.of(context).size.width - 50,
      margin: const EdgeInsets.all(5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: ColorNode.itemBg),
      child: ListTile(
        leading: CircleImage(merchantId: reminder.merchantId),
        title: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  reminder.account ?? '',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                LocaleBuilder(builder: (context, locale) {
                  return Text(
                    sprintf(locale.getText('amount_format'),
                        [formatAmount(reminder.amount)]),
                    style: TextStyle(
                      fontSize: 17,
                      color: ColorNode.Green,
                    ),
                  );
                }),
              ],
            ),
            Positioned(
                right: 1,
                child: GestureDetector(
                    child: Icon(
                      Icons.update,
                      size: 24,
                    ),
                    onTap: () => showDialog(
                        context: context,
                        builder: (context) => showMessage(
                              context,
                              locale.getText('confirm'),
                              locale.getText('reschedule_reminder'),
                              dismissTitle: locale.getText('cancel'),
                              onDismiss: () => Navigator.pop(context),
                              onSuccess: () {
                                Navigator.pop(context);
                                //ReminderPresenter.updateReminder(reminder.id, view: this).update();
                              },
                            ))))
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            LocaleBuilder(
              builder: (_, locale) => Label(
                text: sprintf(locale.getText('days_before_payment'),
                    [date.difference(leftDays).inDays]),
                size: 13,
                weight: FontWeight.w500,
              ),
            ),
            Flexible(
                flex: 1,
                child: Label(
                  text: dateFormat.format(date),
                  size: 13,
                  weight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                )),
          ],
        ),
        onTap: onTap != null ? () => this.onTap!(reminder) : null,
      ),
    );
  }

/* @override
  void onError({String error}) => printLog(error);

  @override
  void onSuccess() => onReschedule();*/
}
