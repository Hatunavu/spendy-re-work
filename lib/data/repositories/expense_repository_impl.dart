import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:spendy_re_work/data/datasources/local/expense_local_data_source.dart';
import 'package:spendy_re_work/data/datasources/remote/expense_datasource.dart';
import 'package:spendy_re_work/data/model/expense/expense_model.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/entities/filter/date_filter_entity.dart';
import 'package:spendy_re_work/domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl extends ExpenseRepository {
  final ExpenseDataSource expenseDataSource;
  final ExpenseLocalDataSource expenseLocalDataSource;

  ExpenseRepositoryImpl({required this.expenseDataSource, required this.expenseLocalDataSource});

  @override
  Future<void> deleteExpense(String uid, String expenseId) =>
      expenseDataSource.removeModel(uid, removeModel: expenseId);

  @override
  Future<void> updateExpense(String uid, ExpenseModel expenseModel) =>
      expenseDataSource.updateModel(uid, expenseModel);

  @override
  Future<bool> createExpense(String uid, ExpenseEntity expenseEntity) async {
    final ExpenseModel expenseModel = expenseEntity.toModel();
    return expenseDataSource.addModel(uid, expenseModel);
  }

  @override
  Future<List<QuerySnapshot>> fillExpenseListWithMonths(
      {String? uid, List? months, DocumentSnapshot? lastDoc}) {
    throw UnimplementedError();
  }

  @override
  Future<List<ExpenseModel>> getExpenseListBetweenDateTime(
      {String? uid, DateFilter? monthFilter, bool endIsLessThanEqual = true}) {
    throw UnimplementedError();
  }

  @override
  Stream<Event> getExpenseListBetweenDateTimeRealtime(String uid, DateFilter monthFilter) {
    throw UnimplementedError();
  }

  @override
  Stream<Event> getExpenseStream(String uid) {
    throw UnimplementedError();
  }

  @override
  bool createExpenseOffline(String uid, ExpenseEntity expenseEntity) {
    final ExpenseModel expenseModel = expenseEntity.toModel();
    return expenseLocalDataSource.addModel(uid, expenseModel);
  }

  @override
  bool deleteExpenseOffline(String uid, String expenseId) =>
      expenseLocalDataSource.removeModel(uid, removeModel: expenseId);

  @override
  bool updateExpenseOffline(String uid, ExpenseModel expense) =>
      expenseLocalDataSource.updateModel(uid, expense);
}
