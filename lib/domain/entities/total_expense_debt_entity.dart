import 'package:spendy_re_work/common/utils/algorithm/settle_debt_algorithm/settle_debt.dart';
import 'package:spendy_re_work/common/extensions/date_time_extensions.dart';

class TotalExpenseDebtEntity {
  Map<int, SettleDebt> dataSettleDebt;

  TotalExpenseDebtEntity(this.dataSettleDebt);

  Map<int, int> toMapTotalExpense() {
    final Map<int, int> map = {};

    dataSettleDebt.forEach((key, value) {
      map[key] = value.totalExpense.toInt();
    });
    return map;
  }

  Map<int, int> toMapTotalOwed() {
    final Map<int, int> map = {};

    dataSettleDebt.forEach((key, value) {
      map[key] = value.totalOwed.toInt();
    });

    return map;
  }

  int totalOwed() {
    int total = 0;
    dataSettleDebt.forEach((key, value) {
      total += value.totalOwed.toInt();
    });
    return total;
  }

  int totalExpense() {
    int total = 0;
    dataSettleDebt.forEach((key, value) {
      total += value.totalExpense.toInt();
    });
    return total;
  }

  static Map<int, int> initDailyMapEmpty() {
    final now = DateTime.now();

    final Map<int, int> map = initialReportDataMap(
        startDay: now.subDay(value: 6), endDate: now.dateTimeYmd);
    return map;
  }

  static Map<int, int> initWeekMapEmpty() {
    final now = DateTime.now();
    final Map<int, int> map = initialReportDataMap(
        startDay: now.startOfWeek(), endDate: now.endOfWeek());
    return map;
  }

  static Map<int, int> initialReportDataMap(
      {DateTime? startDay, DateTime? endDate}) {
    final Map<int, int> reportDataMap = {};
    DateTime reportDay = startDay!;
    while (endDate!.compareTo(reportDay) == 0) {
      reportDataMap[reportDay.day] = 0;
      reportDay = reportDay.add(const Duration(days: 1));
      if (endDate.compareTo(reportDay) == 0) {
        reportDataMap[reportDay.day] = 0;
      }
    }
    return reportDataMap;
  }
}
