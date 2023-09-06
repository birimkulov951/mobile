import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/net/history/modal/filter_date.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/screens/main/history/arguments/history_down_container_arg.dart';
import 'package:mobile_ultra/screens/main/history/widgets/history_button.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:ui_kit/ui_kit.dart';

class DownContainerHeader extends StatefulWidget {
  final HistoryDownContainerArg historyDownContainerArg;

  const DownContainerHeader({
    required this.historyDownContainerArg,
    super.key,
  });

  @override
  _DownContainerHeaderState createState() => _DownContainerHeaderState();
}

class _DownContainerHeaderState extends State<DownContainerHeader> {
  PeriodDateType? filterResult;
  late HistoryDownContainerArg arguments;

  @override
  Widget build(BuildContext context) {
    arguments = widget.historyDownContainerArg;
    filterResult = arguments.filterResult;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 16),
          HistoryButton(
            title: '',
            leadingIcon: Assets.icFilter,
            isPressed: arguments.filterIsPressed,
            onTap: arguments.filterOnTap,
          ),
          if ((filterResult?.periodType?.type != 'none') &&
              filterResult?.dates?.startDate != null &&
              filterResult?.dates?.endDate != null)
            HistoryButton(
              title: _calendarText(),
              isPressed: true,
              trailingIcon: SvgPicture.asset(
                  Assets.icNavigationClose,
                height: 16,
                color: IconAndOtherColors.constant,
              ),
              onTap: arguments.onCalendarTap,
            ),
          if (filterResult?.cardData != null &&
              filterResult!.cardData!.isNotEmpty &&
              arguments.selectedCards.contains(false))
            for (int i = 0; i < filterResult!.cardData!.length; i++)
              HistoryButton(
                title: cardNumberAndTypeText(filterResult!.cardData![i].card!,
                    filterResult!.cardData![i].type!),
                isPressed: true,
                trailingIcon: SvgPicture.asset(
                  Assets.icNavigationClose,
                  height: 16,
                  color: IconAndOtherColors.constant,
                ),
                onTap: () => arguments.onCardClose
                    .call(filterResult!.cardData![i].card!),
              ),
          HistoryButton(
            title: locale.getText('charge'),
            onTap: arguments.chargeOnTap,
            isPressed: arguments.chargeIsPressed,
          ),
          HistoryButton(
            title: locale.getText('withdraw'),
            onTap: arguments.withdrawOnTap,
            isPressed: arguments.withdrawIsPressed,
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  String _calendarText() {
    final startDate = filterResult!.dates!.startDate!;
    final endDate = filterResult!.dates!.endDate!;

    final formattedStartDate =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(startDate);
    final formattedEndDate = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(endDate);
    final startDay = DateTime(formattedStartDate.year, formattedStartDate.month,
        formattedStartDate.day);
    final endDay = DateTime(
        formattedEndDate.year, formattedEndDate.month, formattedEndDate.day);

    if (startDay == endDay) {
      return dateFormatInMonths(startDay);
    }

    return '${dateFormatInMonths(startDay)} - ${dateFormatInMonths(endDay)}';
  }
}
