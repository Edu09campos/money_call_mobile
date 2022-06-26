Map<String, int> startEndDay(DateTime date) {
  DateTime startDay = DateTime(date.year, date.month, date.day, 0, 0, 0, 0);
  int startDayEpoch = startDay.millisecondsSinceEpoch;

  DateTime endDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  int endDayEpoch = endDay.millisecondsSinceEpoch;

  return {"start": startDayEpoch, "end": endDayEpoch};
}

Map<String, int> startEndMonth(DateTime date) {
  DateTime startMonth = DateTime(date.year, date.month, 1, 0, 0, 0, 0);
  int startMonthEpoch = startMonth.millisecondsSinceEpoch;

  DateTime endMonth = DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
  int endMonthEpoch = endMonth.millisecondsSinceEpoch;

  return {"start": startMonthEpoch, "end": endMonthEpoch};
}
