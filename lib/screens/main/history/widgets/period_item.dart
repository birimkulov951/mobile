import 'package:flutter/material.dart';
import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/net/history/modal/filter_date.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/main/history/arguments/period_item_arg.dart';
import 'package:mobile_ultra/screens/main/history/widgets/history_button.dart';
import 'package:mobile_ultra/utils/calendar/table_calendar.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';
import 'package:ui_kit/ui_kit.dart';

class PeriodItem extends StatefulWidget {
  final PeriodItemArg periodItemArg;
  final Function(PeriodType) onTap;
  final PeriodType type;
  final bool isTableCalendarShown;

  const PeriodItem({
    required this.periodItemArg,
    required this.onTap,
    required this.type,
    required this.isTableCalendarShown,
    super.key,
  });

  @override
  PeriodItemState createState() => PeriodItemState();
}

class PeriodItemState extends State<PeriodItem> with TickerProviderStateMixin {
  var _rangeSelectionMode = RangeSelectionMode.toggledOn;
  var _focusedDate = DateTime.now();
  late bool _isCalendarChosen;
  bool _isCalendarTableShown = true;

  @override
  Widget build(BuildContext context) {
    _isCalendarChosen = widget.type == PeriodType.calendar;
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextLocale(
              'period',
              style: TextStylesX.headline,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            child: Row(
              children: [
                HistoryButton(
                  title: locale.getText('week'),
                  onTap: () {
                    _isCalendarTableShown = true;
                    widget.onTap(PeriodType.week);
                  },
                  isPressed: widget.type == PeriodType.week,
                ),
                HistoryButton(
                  title: locale.getText('month'),
                  isPressed: widget.type == PeriodType.month,
                  onTap: () {
                    _isCalendarTableShown = true;
                    widget.onTap(PeriodType.month);
                  },
                ),
                HistoryButton(
                  title: locale.getText('period'),
                  isPressed: widget.type == PeriodType.calendar,
                  trailingIcon: !_isCalendarTableShown
                      ? ActionIcons.chevronRight16.copyWith(
                          color: _isCalendarChosen
                              ? IconAndOtherColors.constant
                              : ColorNode.Dark1,
                        )
                      : ActionIcons.chevronDown16.copyWith(
                          color: _isCalendarChosen
                              ? IconAndOtherColors.constant
                              : ColorNode.Dark1,
                        ),
                  onTap: () {
                    setState(() {
                      _isCalendarChosen = widget.type == PeriodType.calendar;
                      _isCalendarTableShown = !_isCalendarTableShown;
                      widget.onTap(PeriodType.calendar);
                    });
                  },
                ),
              ],
            ),
          ),
          if (_isCalendarChosen && !_isCalendarTableShown)
            TableCalendar(
              rangeSelectionMode: _rangeSelectionMode,
              availableGestures: AvailableGestures.horizontalSwipe,
              currentDay: DateTime.now(),
              onRangeSelected: (start, end, focusedDay) {
                setState(() {
                  _focusedDate = focusedDay;
                  _rangeSelectionMode = RangeSelectionMode.toggledOn;
                  widget.periodItemArg.selectTime(start, end);
                });
              },
              startingDayOfWeek: StartingDayOfWeek.monday,
              rangeStartDay: widget.periodItemArg.startDate,
              rangeEndDay: widget.periodItemArg.endDate,
              calendarStyle: const CalendarStyle(
                rangeHighlightColor: ColorNode.Background,
                rangeStartDecoration: BoxDecoration(
                  color: ColorNode.Green,
                  shape: BoxShape.circle,
                ),
                rangeEndDecoration: BoxDecoration(
                  color: ColorNode.Green,
                  shape: BoxShape.circle,
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStylesX.captionButtonSecondary,
                weekendStyle: TextStylesX.captionButtonSecondary,
              ),
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
              },
              weekendDays: const [
                DateTime.saturday,
                DateTime.sunday,
              ],
              locale: locale.prefix,
              headerStyle: HeaderStyle(
                titleTextStyle: TextStylesX.headline,
                titleCentered: true,
                leftChevronIcon: Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorNode.Background,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_outlined,
                    size: 16,
                    color: ColorNode.MainSecondary,
                  ),
                ),
                rightChevronIcon: Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorNode.Background,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 16,
                    color: ColorNode.MainSecondary,
                  ),
                ),
              ),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              firstDay: DateTime.now().subtract(const Duration(days: 365)),
              focusedDay: _focusedDate,
            ),
        ],
      ),
    );
  }

  void hideTableCalendar() => _isCalendarTableShown = true;
}
