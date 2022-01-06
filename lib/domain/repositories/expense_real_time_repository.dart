import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';

abstract class ExpenseRealTimeRepository {
  Query firstPageExpenseQuery(String uid);

  Query moreExpenseQuery({@required String uid, @required int lastTimeSort});

  Future<void> updateExpense(
      {@required String uid, @required ExpenseEntity expenseEntity});

  Future<void> deleteExpense(
      {@required String uid, @required String expenseId});
}
