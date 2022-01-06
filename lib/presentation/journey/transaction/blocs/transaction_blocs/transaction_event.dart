import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';

abstract class TransactionEvent extends Equatable {}

class ListenToExpensesRealTimeEvent extends TransactionEvent {
  final List<ExpenseEntity> expenseList;
  final ExpenseEntity? selectExpense;

  ListenToExpensesRealTimeEvent(
      {required this.expenseList, this.selectExpense});

  @override
  List<Object> get props => [expenseList];
}

class TransactionInitialEvent extends TransactionEvent {
  final GroupEntity group;

  TransactionInitialEvent(this.group);

  @override
  List<Object> get props => [group];
}

class UpdateExpenseEvent extends TransactionEvent {
  final List<ExpenseEntity>? expenseDetailRecentlyList;
  final ExpenseEntity? selectExpenseDetail;
  final int? numberOfNotifyUnread;

  UpdateExpenseEvent({
    this.expenseDetailRecentlyList,
    this.selectExpenseDetail,
    this.numberOfNotifyUnread,
  });

  @override
  List<Object?> get props =>
      [expenseDetailRecentlyList, selectExpenseDetail, numberOfNotifyUnread];
}

class OpenSlideEvent extends TransactionEvent {
  final ExpenseEntity selectExpense;

  OpenSlideEvent({required this.selectExpense});

  @override
  List<Object> get props => [selectExpense];
}

class CloseSlideEvent extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class DeleteExpenseEvent extends TransactionEvent {
  final ExpenseEntity expense;
  final String groupId;

  DeleteExpenseEvent({required this.expense, required this.groupId});

  @override
  List<Object> get props => [expense, groupId];
}

class ShowTransactionDetailEvent extends TransactionEvent {
  final ExpenseEntity selectExpense;
  final int? selectIndex;

  ShowTransactionDetailEvent(
      {required this.selectExpense, required this.selectIndex});

  @override
  List<Object?> get props => [selectExpense, selectIndex];
}

class LoadMoreEvent extends TransactionEvent {
  final GroupEntity group;

  LoadMoreEvent(this.group);

  @override
  List<Object> get props => [group];
}

class ClearTransactionEvent extends TransactionEvent {
  @override
  List<Object> get props => [];
}
