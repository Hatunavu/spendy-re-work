import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';

abstract class TransactionUxEvent extends Equatable {}

class OpenSlideEvent extends TransactionUxEvent {
  final ExpenseEntity selectExpense;

  OpenSlideEvent({required this.selectExpense});

  @override
  List<Object> get props => [selectExpense];
}

class CloseSlideEvent extends TransactionUxEvent {
  @override
  List<Object> get props => [];
}

class DeleteExpenseEvent extends TransactionUxEvent {
  final ExpenseEntity expense;

  DeleteExpenseEvent({required this.expense});

  @override
  List<Object> get props => [expense];
}

class ShowTransactionDetailEvent extends TransactionUxEvent {
  final ExpenseEntity selectExpense;
  final int selectIndex;

  ShowTransactionDetailEvent(
      {required this.selectExpense, required this.selectIndex});

  @override
  List<Object> get props => [selectExpense, selectIndex];
}

class LoadMoreEvent extends TransactionUxEvent {
  @override
  List<Object> get props => [];
}
