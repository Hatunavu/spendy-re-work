import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';

class ExpenseDataEntity {
  final ExpenseEntity? expense;
  final bool? isAds;

  ExpenseDataEntity({this.expense, this.isAds});

  factory ExpenseDataEntity.fromExpenseEntity(
          {ExpenseEntity? expense, int? index}) =>
      ExpenseDataEntity(expense: expense, isAds: index! % 5 == 0 && index != 0);
}
