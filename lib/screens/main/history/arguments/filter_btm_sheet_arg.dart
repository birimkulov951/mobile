import 'package:mobile_ultra/net/history/modal/filter_date.dart';

class FilterBtmSheetArg {
  final Function(
    PeriodDateType? filterResult,
    List<bool> selectedCards,
  ) showOnTap;
  final Function() resetOnTap;

  FilterBtmSheetArg({
    required this.showOnTap,
    required this.resetOnTap,
  });
}
