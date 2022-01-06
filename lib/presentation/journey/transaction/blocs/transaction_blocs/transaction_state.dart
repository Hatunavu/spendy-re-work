import 'package:spendy_re_work/common/constants/image_data_state.dart';
import 'package:spendy_re_work/common/enums/slide_state.dart';
import 'package:spendy_re_work/common/enums/data_state.dart';
import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_data_entity.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';

abstract class TransactionState extends Equatable {
  final List<ExpenseEntity>? expenseList;
  final Map<int, List<ExpenseEntity>>? expenseOfDayMap;
  final bool? isUnread;

  TransactionState(this.expenseList, this.isUnread, this.expenseOfDayMap);
}

class TransactionInitialState extends TransactionState {
  final SlideState? slideState;
  final DataState? dataState;
  final ImageDataState? imageDataState;
  final ExpenseEntity? selectExpense;
  @override
  final bool? isUnread;
  final Map<int, List<ExpenseDataEntity>>? expenseRecentOfDayMap;

  TransactionInitialState({
    List<ExpenseEntity>? expenseList,
    Map<int, List<ExpenseEntity>>? expenseOfDayMap,
    this.slideState,
    this.dataState,
    this.expenseRecentOfDayMap,
    this.isUnread = false,
    this.imageDataState = ImageDataState.loading,
    this.selectExpense,
  }) : super(expenseList, isUnread, expenseOfDayMap);

  TransactionInitialState update({
    List<ExpenseEntity>? expenseList,
    Map<int, List<ExpenseEntity>>? expenseOfDayMap,
    DataState? dataState,
    SlideState? slideState,
    ImageDataState? imageDataState,
    ExpenseEntity? selectExpense,
    bool? isUnread,
    Map<int, List<ExpenseDataEntity>>? expenseRecentOfDayMap,
  }) {
    final TransactionInitialState state = TransactionInitialState(
        expenseList: expenseList ?? this.expenseList,
        slideState: slideState ?? this.slideState,
        expenseOfDayMap: expenseOfDayMap ?? this.expenseOfDayMap,
        expenseRecentOfDayMap:
            expenseRecentOfDayMap ?? this.expenseRecentOfDayMap,
        dataState: dataState ?? this.dataState,
        imageDataState: imageDataState ?? this.imageDataState,
        selectExpense: selectExpense ?? this.selectExpense,
        isUnread: isUnread ?? this.isUnread);
    return state;
  }

  @override
  List<Object?> get props => [
        expenseList,
        slideState,
        dataState,
        isUnread,
        expenseOfDayMap,
        expenseOfDayMap,
        expenseRecentOfDayMap,
        selectExpense,
      ];
}

class TransactionLoadingState extends TransactionState {
  TransactionLoadingState(
      {List<ExpenseEntity>? expenseList,
      bool? isUnread,
      Map<int, List<ExpenseEntity>>? expenseOfDayMap})
      : super(expenseList, isUnread, expenseOfDayMap);

  @override
  List<Object> get props => [];
}
