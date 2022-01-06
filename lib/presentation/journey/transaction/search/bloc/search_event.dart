import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';

abstract class SearchEvent extends Equatable {}

class SearchInitialEvent extends SearchEvent {
  final GroupEntity? group;

  SearchInitialEvent({this.group});
  @override
  List<Object?> get props => [group];
}

class SearchListenAllExpenseEvent extends SearchEvent {
  final List<ExpenseEntity> expenses;

  SearchListenAllExpenseEvent(this.expenses);

  @override
  List<Object> get props => [expenses];
}

class SearchListenRecentEvent extends SearchEvent {
  final List<ExpenseEntity>? recentlyList;

  SearchListenRecentEvent({this.recentlyList});

  @override
  List<Object?> get props => [recentlyList];
}

class SearchListenExpenseResult extends SearchEvent {
  final List<ExpenseEntity>? expenseList;

  SearchListenExpenseResult({this.expenseList});

  @override
  List<Object?> get props => [expenseList];
}

class TypingSearchFromEvent extends SearchEvent {
  final String keyWord;

  TypingSearchFromEvent({
    required this.keyWord,
  });

  @override
  List<Object> get props => [keyWord];
}

class SearchExpenseEvent extends SearchEvent {
  final String keyWord;

  SearchExpenseEvent({required this.keyWord});

  @override
  List<Object> get props => [keyWord];
}

class OpenSlideSearchTransactionItemEvent extends SearchEvent {
  final ExpenseEntity selectExpenseDetail;

  OpenSlideSearchTransactionItemEvent({required this.selectExpenseDetail});

  @override
  List<Object> get props => [selectExpenseDetail];
}

class CloseSlideSearchTransactionItemEvent extends SearchEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}

class CleanTextEvent extends SearchEvent {
  @override
  List<Object> get props => [];
}

class UpdateSearchRecentlyEvent extends SearchEvent {
  final ExpenseEntity expenseDetailEntity;

  UpdateSearchRecentlyEvent(
    this.expenseDetailEntity,
  );

  @override
  List<Object> get props => [
        expenseDetailEntity,
      ];
}

class DeleteExpenseSearchEvent extends SearchEvent {
  final ExpenseEntity expenseDetail;
  final String? keyWord;

  DeleteExpenseSearchEvent({required this.expenseDetail, this.keyWord});

  @override
  List<Object?> get props => [expenseDetail, keyWord];
}

class LoadMoreEvent extends SearchEvent {
  final String keyWord;

  LoadMoreEvent({required this.keyWord});

  @override
  List<Object> get props => throw UnimplementedError();
}

class GetExpenseDetailEvent extends SearchEvent {
  final ExpenseEntity? expense;
  final int? index;
  final bool? isRecent;

  GetExpenseDetailEvent({this.expense, this.index, this.isRecent});

  @override
  List<Object?> get props => [expense, index, isRecent];
}
