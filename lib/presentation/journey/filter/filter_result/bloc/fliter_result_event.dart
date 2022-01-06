import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/entities/filter/filter.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';

abstract class FilterResultEvent extends Equatable {}

class ListenToFilter extends FilterResultEvent {
  final Filter filter;
  final GroupEntity? group;
  final String? languageCode;

  ListenToFilter({required this.filter, this.languageCode, this.group});

  @override
  List<Object?> get props => [filter, languageCode, group];
}

class FilterResultInitialEvent extends FilterResultEvent {
  final List<ExpenseEntity> expenseList;
  final Filter filter;

  final String? languageCode;

  FilterResultInitialEvent(
      {required this.expenseList, required this.filter, this.languageCode});
  @override
  List<Object> get props => [expenseList, filter, languageCode!];
}

class RemoveTagEvent extends FilterResultEvent {
  final String key;

  RemoveTagEvent({required this.key});

  @override
  List<Object> get props => [key];
}

class LoadMoreEvent extends FilterResultEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}

class OpenSlideEvent extends FilterResultEvent {
  final ExpenseEntity selectExpense;

  OpenSlideEvent({required this.selectExpense});

  @override
  List<Object> get props => [selectExpense];
}

class CloseSlideEvent extends FilterResultEvent {
  @override
  List<Object> get props => [];
}

class DeleteExpenseEvent extends FilterResultEvent {
  final ExpenseEntity expense;

  DeleteExpenseEvent({required this.expense});

  @override
  List<Object> get props => [expense];
}

class ShowTransactionDetailEvent extends FilterResultEvent {
  final ExpenseEntity selectExpense;
  final int selectIndex;

  ShowTransactionDetailEvent(
      {required this.selectExpense, required this.selectIndex});

  @override
  List<Object> get props => [selectExpense, selectIndex];
}
