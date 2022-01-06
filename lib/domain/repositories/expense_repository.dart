import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:spendy_re_work/data/model/expense/expense_model.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/entities/filter/date_filter_entity.dart';

abstract class ExpenseRepository {
  Future<List<ExpenseModel>> getExpenseListBetweenDateTime(
      {String? uid, DateFilter? monthFilter, bool endIsLessThanEqual = true});

  Stream<Event> getExpenseListBetweenDateTimeRealtime(String uid, DateFilter monthFilter);

  Stream<Event> getExpenseStream(String uid);

  Future<void> deleteExpense(String uid, String expenseId);

  Future<void> updateExpense(String uid, ExpenseModel expenseModel);

  Future<List<QuerySnapshot>> fillExpenseListWithMonths(
      {String? uid, List<DateFilter>? months, DocumentSnapshot? lastDoc});

  /// REWORK
  Future<bool> createExpense(String uid, ExpenseEntity expenseEntity);

  bool createExpenseOffline(String uid, ExpenseEntity expenseEntity);
  bool updateExpenseOffline(String uid, ExpenseModel expenseModel);
  bool deleteExpenseOffline(String uid, String expenseId);
}
