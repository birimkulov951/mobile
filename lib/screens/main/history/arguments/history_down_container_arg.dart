import 'package:mobile_ultra/net/history/modal/filter_date.dart';

class HistoryDownContainerArg {
  final PeriodDateType? filterResult;
  final List<bool> selectedCards;
  final Function() filterOnTap;
  final Function() chargeOnTap;
  final Function() withdrawOnTap;
  final Function() onCalendarTap;
  final Function(String value) onCardClose;
  final bool filterIsPressed;
  final bool chargeIsPressed;
  final bool withdrawIsPressed;

  const HistoryDownContainerArg({
    required this.filterResult,
    required this.selectedCards,
    required this.filterOnTap,
    required this.chargeOnTap,
    required this.withdrawOnTap,
    required this.onCalendarTap,
    required this.onCardClose,
    required this.filterIsPressed,
    required this.chargeIsPressed,
    required this.withdrawIsPressed,
  });

  @override
  String toString() {
    return 'HistoryDownContainerArg{filterResult: $filterResult, filterOnTap: $filterOnTap, chargeOnTap: $chargeOnTap, withdrawOnTap: $withdrawOnTap, filterIsPressed: $filterIsPressed, chargeIsPressed: $chargeIsPressed, withdrawIsPressed: $withdrawIsPressed}';
  }
}
