import 'package:spendy_re_work/common/extensions/date_time_extensions.dart';
import 'package:spendy_re_work/domain/entities/filter/date_filter_entity.dart';

class DateUseCase {
  Future<Map<String, DateFilter>> getAllMonths(
      int year, String languageCode, DateTime oldExpense) async {
    int maxMonth = 12;
    int minMonth = 1;
    final DateTime now = DateTime.now();
    if (now.year == year) {
      maxMonth = now.month;
    }
    if (year == oldExpense.year) {
      minMonth = oldExpense.month;
    }
    final Map<String, DateFilter> timerMap = {};
    for (int index = maxMonth; index >= minMonth; index--) {
      final int currentMonth = index;
      final DateTime date = DateTime(year, currentMonth, 1);
      timerMap[date.formatDateMMMyyyy(languageCode)] =
          DateFilter(start: date.earlyMonth, end: date.endMonth);
    }

    return timerMap;
  }

/*
  Future<List<DateFilter>> convertDateTimeListToDateFilterList(
      {List<DateTime> dateTimeFilterList}) async {
    List<DateFilter> dateFilterList = [];
    for (final DateTime date in dateTimeFilterList) {
      dateFilterList.add(DateFilter(
          start: date.earlyMonth,
          end: date.endMonth));
    }
    return dateFilterList;
  }*/

  Future<bool> checkNoEmptySelectMonthSet(Set<String>? monthSet) async {
    if (monthSet != null && monthSet.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<DateTime>> getDateFilterFilter(
      {List<DateFilter>? monthFilterList}) async {
    if (monthFilterList != null && monthFilterList.isNotEmpty) {
      final List<DateTime> dateTimeFilterList = [];
      for (final DateFilter month in monthFilterList) {
        dateTimeFilterList
            .add(DateTime.fromMillisecondsSinceEpoch(month.start!));
      }
      return dateTimeFilterList;
    } else {
      return [];
    }
  }

  Future<List<DateTime>> removeDateFilter(
      {List<DateTime>? dateFilterList, DateTime? dateFilter}) async {
    dateFilterList!.remove(dateFilter);
    return dateFilterList;
  }
}
