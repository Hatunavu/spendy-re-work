import 'package:flutter/cupertino.dart';

import 'package:spendy_re_work/domain/entities/report_expense_entity.dart';
import 'package:spendy_re_work/domain/entities/report_total_category_spend_entity.dart';

class ReportListExpenseEntity {
  List<ReportExpenseEntity>? _listExpense;
  Map<int, List<ReportExpenseEntity>>?
      mapListExpenseWithMonth; // map list expense with month. Eg: {1: [ReportExpenseEntity, ReportExpenseEntity]}

  ReportListExpenseEntity({List<ReportExpenseEntity>? listExpense}) {
    _listExpense = listExpense;
    _mapListExpenseToMapExpensesWithMonth();
  }

  // map list expense to map of expense with month
  void _mapListExpenseToMapExpensesWithMonth() {
    mapListExpenseWithMonth = {};
    for (int i = 1; i <= 12; i++) {
      mapListExpenseWithMonth![i] = [];
    }
    for (final element in _listExpense ?? []) {
      final createAtMonth = DateTime.fromMicrosecondsSinceEpoch(
              element.transactionEntity!.spendTime! * 1000)
          .month;
      mapListExpenseWithMonth![createAtMonth]!.add(element);
    }
  }

  Map<int, int> toMapTotalMoneyWithMonth() {
    final Map<int, int> mapTotalMoneyWithMonth = {};
    for (int i = 1; i <= 12; i++) {
      mapTotalMoneyWithMonth[i] = 0;
    }
    mapListExpenseWithMonth!.forEach((key, expenseList) {
      for (final element in expenseList) {
        mapTotalMoneyWithMonth[key] =
            mapTotalMoneyWithMonth[key]! + element.transactionEntity!.amount;
      }
    });

    return mapTotalMoneyWithMonth;
  }

  Map<String, ReportTotalCateEntity> toMapWithKeyCategoryOfMonth(int month) {
    final Map<String, ReportTotalCateEntity> mapListTotalWithCate = {};
    for (final element in mapListExpenseWithMonth?[month] ?? []) {
      final list = mapListTotalWithCate[element.categoryEntity!.name];
      if (list == null) {
        mapListTotalWithCate[element.categoryEntity!.name!] =
            ReportTotalCateEntity(
          categoryEntity: element.categoryEntity!,
        );
      }
      mapListTotalWithCate[element.categoryEntity!.name]!.total +=
          element.transactionEntity!.spend!;
    }

    // sort with value
    final mapEntries = mapListTotalWithCate.entries.toList()
      ..sort((a, b) {
        return b.value.total.toInt() - a.value.total.toInt();
      });

    mapListTotalWithCate
      ..clear()
      ..addEntries(mapEntries);

    debugPrint(
        ' ReportListExpenseEntity - toMapWithKeyCategoryOfMonth: $mapListTotalWithCate');

    return mapListTotalWithCate;
  }

  int getTotalMoneyOfMonth(int month) {
    int total = 0;
    for (final element in mapListExpenseWithMonth?[month] ?? []) {
      total += element.transactionEntity!.spend! as int;
    }

    return total;
  }

  int getOwedOfMonth(int month) {
    int result = 0;
    for (final element in mapListExpenseWithMonth?[month] ?? []) {
      final int owed = element.whoPaid!.amount! - element.forWho!.amount!;
      if (owed > 0) {
        result += owed;
      }
    }

    return result;
  }
}
