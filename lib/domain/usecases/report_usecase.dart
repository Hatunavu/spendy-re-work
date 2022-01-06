import 'package:spendy_re_work/common/extensions/date_time_extensions.dart';
import 'package:spendy_re_work/common/utils/algorithm/settle_debt_algorithm/settle_debt.dart';
import 'package:spendy_re_work/domain/entities/category_entity.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_detail_entity.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/entities/report_total_category_spend_entity.dart';
import 'package:spendy_re_work/domain/repositories/expense_repository.dart';
import 'package:spendy_re_work/domain/repositories/participant_repository.dart';
import 'package:spendy_re_work/domain/repositories/report_repository.dart';
import 'package:spendy_re_work/domain/repositories/transaction_repository.dart';
import 'package:spendy_re_work/domain/usecases/categories_usecase.dart';

class ReportUseCase {
  final ExpenseRepository expenseRepository;
  final ReportRepository reportRepository;
  final ParticipantRepository participantRepository;
  final TransactionRepository transactionRepository;

  final CategoriesUseCase categoriesUseCase;

  ReportUseCase({
    required this.expenseRepository,
    required this.reportRepository,
    required this.transactionRepository,
    required this.participantRepository,
    required this.categoriesUseCase,
  });

  Future<List<ExpenseDetailEntity>> _fetchListDetailEntity(
      List<ExpenseEntity> listExpense) async {
    final List<ExpenseDetailEntity> listExpenseDetail = [];

    // check `for who` in a element of expense
    // for (int i = 0; i < listExpense.length; i++) {
    //   final category = await categoryRepository.getCategoryById(
    //       id: listExpense[i].categoryNode);
    //
    //   if (category == null) {
    //     continue;
    //   }
    //
    //   final transaction = await transactionRepository
    //       .getTransactionById(listExpense[i].transactionNode);
    //
    //   if (transaction == null) {
    //     continue;
    //   }
    //   listExpenseDetail.add(ExpenseDetailEntity(
    //     categoryEntity: category,
    //     expenseEntity: listExpense[i],
    //     transactionEntity: transaction,
    //   ));
    // }
    return listExpenseDetail;
  }

  Future<Map<int, List<ExpenseDetailEntity>>> mapListListExpenseDetailWithMonth(
      List<ExpenseEntity> listExpense) async {
    final Map<int, List<ExpenseDetailEntity>> mapListExpenseWithMonth = {};

    final listExpenseDetail = await _fetchListDetailEntity(listExpense);

    for (int i = 1; i <= 12; i++) {
      mapListExpenseWithMonth[i] = [];
    }
    for (final element in listExpenseDetail) {
      final createAtMonth = DateTime.fromMicrosecondsSinceEpoch(
              element.transactionEntity!.spendTime * 1000)
          .month;
      mapListExpenseWithMonth[createAtMonth]!.add(element);
    }
    return mapListExpenseWithMonth;
  }

  Map<String, ReportTotalCateEntity> getMapTotalExpenseWithKeyCategoryOfMonth(
      List<ExpenseDetailEntity> listExpenseWithMonth) {
    final Map<String, ReportTotalCateEntity> mapListTotalWithCate = {};

    for (final element in listExpenseWithMonth) {
      final list = mapListTotalWithCate[element.categoryEntity!.name];
      if (list == null) {
        mapListTotalWithCate[element.categoryEntity!.name!] =
            ReportTotalCateEntity(categoryEntity: element.categoryEntity);
      }
      mapListTotalWithCate[element.categoryEntity!.name]!.total +=
          element.transactionEntity!.amount;
    }
    // sort with value
    final mapEntries = mapListTotalWithCate.entries.toList()
      ..sort((a, b) {
        return b.value.total.toInt() - a.value.total.toInt();
      });

    mapListTotalWithCate
      ..clear()
      ..addEntries(mapEntries);

    return mapListTotalWithCate;
  }

  Map<int, int> getMapTotalExpenseWithMonth(
      Map<int, SettleDebt> mapSettleDebtWithMonth) {
    final Map<int, int> mapTotalExpenseWithMonth = {};

    mapSettleDebtWithMonth.forEach((key, value) {
      mapTotalExpenseWithMonth[key] = value.totalExpense.toInt();
    });

    return mapTotalExpenseWithMonth;
  }

  /// HOME REPORT
  Stream listenToExpensesHomeReport(
          {String? uid, DateTime? startDay, DateTime? endDate}) =>
      reportRepository.listenToHomeReport(
        uid: uid!,
        startDay: startDay!.millisecondsSinceEpoch,
        endDate: endDate!.millisecondsSinceEpoch,
      );

  Future<Map<int, int>> getTotalAmountOfDayMap(
      {List<ExpenseEntity>? expenseList,
      Map<int, int>? totalAmountOfDayMap,
      List<DateTime>? dateList}) async {
    // #1: Performing a loop to get all expenses in 7 Days
    for (final ExpenseEntity expense in expenseList!) {
      // #2: Check out in the last 7 days has expense any
      final DateTime expenseDate =
          DateTime.fromMillisecondsSinceEpoch(expense.spendTime).dateTimeYmd;
      if (dateList!.contains(expenseDate)) {
        // #3: If exist, make a report
        final int expenseDay =
            DateTime.fromMillisecondsSinceEpoch(expense.spendTime).day;
        // the value of totalAmountOfDayMap must always exist before
        // the function is executed
        if (totalAmountOfDayMap![expenseDay] != null) {
          totalAmountOfDayMap[expenseDay] =
              totalAmountOfDayMap[expenseDay]! + expense.amount;
        }
      }
    }
    return totalAmountOfDayMap!;
  }

  int getTotalAmountOfWeek(List<int> amountList) {
    int totalAmount = 0;
    for (final int amount in amountList) {
      totalAmount += amount;
    }
    return totalAmount;
  }

  /// REPORT PAGE
  ///
  Future<Map<int, int>> getTotalAmountOfMonthMap(
      {List<ExpenseEntity>? expenseList,
      Map<int, int>? totalAmountOfDayMap,
      int? selectYear}) async {
    for (final ExpenseEntity expense in expenseList!) {
      // #1: Check expense year is equal selectYear or not
      if (DateTime.fromMillisecondsSinceEpoch(expense.spendTime).year ==
          selectYear) {
        final int expenseMonth =
            DateTime.fromMillisecondsSinceEpoch(expense.spendTime).month;
        // the value of totalAmountOfDayMap must always exist before
        // the function is executed
        if (totalAmountOfDayMap![expenseMonth] != null) {
          totalAmountOfDayMap[expenseMonth] =
              totalAmountOfDayMap[expenseMonth]! + expense.amount;
        }
      }
    }
    return totalAmountOfDayMap!;
  }

  void requestMoreReportDataByYear(
          {String? uid, int? startDay, int? endDate}) =>
      reportRepository.loadMoreReportYearData(
          uid: uid, startDay: startDay, endDate: endDate);

  Future<ReportOfMonth> getReportOfMonth({
    List<ExpenseEntity>? expenseList,
    int? selectMonth,
    int? selectYear,
    List<CategoryEntity>? categoryList,
  }) async {
    // expenseList value is expenseList Of Year
    // totalAmount value is totalAmount of Month
    int totalAmount = 0;
    // expenseMonthList value is total amount of Year
    final List<ExpenseEntity> expenseMonthList = [];
    List<ReportByCategory> reportByCategoryList = [];
    // #1: Check expense is existence of the selectMonth or not
    for (final ExpenseEntity expense in expenseList!) {
      final int expenseMonth =
          DateTime.fromMillisecondsSinceEpoch(expense.spendTime).month;
      final int expenseYear =
          DateTime.fromMillisecondsSinceEpoch(expense.spendTime).year;
      // #2: Check expenseMonth is equal selectMonth or not
      if (expenseMonth == selectMonth && expenseYear == selectYear) {
        totalAmount += expense.amount;
        expenseMonthList.add(expense);
      }
    }

    // #3: Get all Report by Category in selectMonth
    reportByCategoryList = await getReportByCategoryList(
      expenseList: expenseMonthList,
      totalAmount: totalAmount,
      categoryList: categoryList!,
    )
      ..sort(
          (reportA, reportB) => reportB.percent!.compareTo(reportA.percent!));
    return ReportOfMonth(
      totalAmount: totalAmount,
      reportByCategoryList: reportByCategoryList,
    );
  }

  Future<List<ReportByCategory>> getReportByCategoryList(
      {List<ExpenseEntity>? expenseList,
      int? totalAmount,
      List<CategoryEntity>? categoryList}) async {
    List<ReportByCategory> reportByCategoryList = [];
    // expenseList is expense list data in month
    // totalAmount is total amount in month

    // #1: Create a map to store ReportByCategory objects
    final Map<String, ReportByCategory> reportByCategoryMap =
        Map<String, ReportByCategory>();
    // #2: Check expense list is exist or not
    if (expenseList != null && expenseList.isNotEmpty) {
      for (final ExpenseEntity expense in expenseList) {
        // #3: Check reportByCategoryMap[expense.category] is exist or not
        if (reportByCategoryMap[expense.category] == null) {
          // #4.1: Not exist, create ReportByCategory
          final CategoryEntity? categoryEntity =
              await categoriesUseCase.getCategoryByName(
                  categoryList: categoryList,
                  currentCategoryName: expense.category);
          reportByCategoryMap[expense.category] = ReportByCategory(
            category: categoryEntity!,
            amount: expense.amount,
            percent: ((expense.amount / totalAmount!) * 1000).round() / 10,
          );
        } else {
          // #4.2: Exist, update ReportByCategory object
          reportByCategoryMap[expense.category]!
              .update(amount: expense.amount, total: totalAmount!);
        }
      }
      reportByCategoryList = reportByCategoryMap.values.toList();
    }
    return reportByCategoryList;
  }

  void clearReportData() => reportRepository.clear();
}

class ReportOfMonth {
  int? totalAmount;
  List<ReportByCategory>? reportByCategoryList;

  ReportOfMonth({
    this.totalAmount,
    this.reportByCategoryList,
  });

  factory ReportOfMonth.normal() =>
      ReportOfMonth(totalAmount: 0, reportByCategoryList: []);
}

class ReportByCategory {
  CategoryEntity? category;
  double? percent;
  int? amount;

  ReportByCategory({
    this.category,
    this.percent,
    this.amount,
  });

  void update({int? amount, int? total}) {
    this.amount = this.amount! + amount!;
    percent = ((this.amount! / total!) * 1000).round() / 10;
  }

  @override
  String toString() {
    return 'ReportByCategory{category: $category, percent: $percent, amount: $amount}';
  }
}
