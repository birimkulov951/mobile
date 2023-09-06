class PeriodItemArg {
  final DateTime startDate;
  final DateTime endDate;
  final Function(DateTime start, DateTime? end) selectTime;

  PeriodItemArg({
    required this.selectTime,
    required this.startDate,
    required this.endDate,
  });
}
