import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_detail_entity.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/entities/filter/date_filter_entity.dart';
import 'package:spendy_re_work/domain/entities/filter/filter.dart';
import 'package:spendy_re_work/domain/repositories/expense_repository.dart';
import 'package:spendy_re_work/domain/repositories/filter_repository.dart';
import 'package:spendy_re_work/domain/repositories/transaction_repository.dart';
import 'package:spendy_re_work/domain/usecases/date_usecase.dart';
import 'package:spendy_re_work/presentation/journey/filter/__mock__/group_participant_map.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_constants.dart';

import 'categories_usecase.dart';

class FilterUseCase {
  final ExpenseRepository expenseRepository;
  final TransactionRepository transactionRepository;
  final FilterRepository filterRepository;
  final CategoriesUseCase categoriesUseCase;
  final DateUseCase dateUseCase;

  FilterUseCase({
    required this.expenseRepository,
    required this.filterRepository,
    required this.categoriesUseCase,
    required this.dateUseCase,
    required this.transactionRepository,
  });

  Stream listenToFilter(
          {required String uid,
          required String groupId,
          required Filter filter}) =>
      filterRepository.listenToFilter(
          uid: uid, groupId: groupId, filter: filter);

  void loadMoreFilter(
          {required String uid,
          required String groupId,
          required Filter filter}) =>
      filterRepository.loadMoreFilter(
          uid: uid, groupId: groupId, filter: filter);

  void renewFilter(
          {required String uid,
          required String groupId,
          required Filter filter}) =>
      filterRepository.renewFilter(uid: uid, groupId: groupId, filter: filter);

  Future<bool> checkNotEmptySelectGroupSet(Set<String>? participantSet) async {
    if (participantSet != null && participantSet.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkActiveButton({
    String? category,
    String? month,
    String? group,
    double? startRange,
    double? endRange,
    bool infinitySpendRange = false,
  }) async {
    if ((category != null && category.isNotEmpty) ||
        (month != null && month.isNotEmpty) ||
        (group != null && group.isNotEmpty) ||
        startRange! > 0 ||
        endRange! < FilterConstants.maxExpenseRange ||
        infinitySpendRange) {
      return true;
    }
    return false;
  }

  Future<int> getSelectOptionTypeNumbers({
    String? category,
    String? month,
    String? group,
    double? startRange,
    double? endRange,
  }) async {
    int temp = 0;
    if (category != null && category.isNotEmpty) {
      temp++;
    }
    if (month != null && month.isNotEmpty) {
      temp++;
    }
    if (group != null && group.isNotEmpty) {
      temp++;
    }
    if (startRange! > FilterConstants.minExpenseRange ||
        endRange! < FilterConstants.maxExpenseRange) {
      temp++;
    }
    return temp;
  }

  Future<DateFilter?> getDateFilter(
      Map<String, DateFilter> dateFilterMap, String selectMonth) async {
    final DateFilter? dateFilter = dateFilterMap[selectMonth];
    return dateFilter;
  }

  Future<List<int>> getGroupFilter(List<String> keys) async {
    final List<int> groupFilters = [];
    for (final String key in keys) {
      final int number = groupParticipantMap[key]!;
      groupFilters.add(number);
    }
    return groupFilters;
  }

  Future<List<ExpenseDetailEntity>> fillSpendRange(
      {List<ExpenseDetailEntity>? currentExpenseDetails,
      Filter? filter}) async {
    if (filter!.range == null) {
      return currentExpenseDetails!;
    }
    final List<ExpenseDetailEntity> filterExpenseDetailList = [];
    for (final expenseDetail in currentExpenseDetails!) {
      if (expenseDetail.transactionEntity!.amount >= filter.range!.start! &&
          expenseDetail.transactionEntity!.amount <= filter.range!.end!) {
        filterExpenseDetailList.add(expenseDetail);
      }
    }
    return filterExpenseDetailList;
  }

  Future<List<QueryDocumentSnapshot>> toFuture(
      Stream<List<QueryDocumentSnapshot>> resultDocsStream) async {
    List<QueryDocumentSnapshot> resultDocs = [];
    resultDocsStream.listen((value) {
      resultDocs = value;
    });
    return resultDocs;
  }

  Future<List<ExpenseEntity>> fillAmount(
      {List<ExpenseEntity>? expenseList, Filter? filter}) async {
    List<ExpenseEntity> fillExpenseList = [];
    // #1: Check Expense Range is exist or not
    if (filter!.range != null && filter.range!.isSafe) {
      // #2.1: Exist, fill out expense in the range
      final int min = filter.range!.start!;
      final int max = filter.range!.end!;
      for (final ExpenseEntity expense in expenseList!) {
        if (expense.amount >= min && expense.amount <= max) {
          fillExpenseList.add(expense);
        }
      }
    } else {
      // # 2.2: Not exist, keep expenseList
      fillExpenseList = expenseList!;
    }
    return fillExpenseList;
  }

  Future<ExpenseEntity> getExpenseWithSpendTime(String uid, bool descending) =>
      transactionRepository.getExpenseWithSpendTime(uid, descending);
}
