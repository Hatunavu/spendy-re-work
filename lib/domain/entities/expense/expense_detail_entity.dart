import 'package:spendy_re_work/domain/entities/category_entity.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/entities/transaction_entity.dart';

class ExpenseDetailEntity {
  String? expenseId;
  ExpenseEntity? expenseEntity;
  CategoryEntity? categoryEntity;
  TransactionEntity? transactionEntity;
  int? payerNumbers;

  ExpenseDetailEntity({
    this.expenseId,
    this.categoryEntity,
    this.expenseEntity,
    this.transactionEntity,
    this.payerNumbers,
  });
}
