import 'package:spendy_re_work/common/constants/image_data_state.dart';
import 'package:spendy_re_work/common/enums/data_state.dart';
import 'package:spendy_re_work/common/enums/slide_state.dart';
import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';

abstract class TransactionUxState extends Equatable {
  final List<ExpenseEntity>? expenseList;

  TransactionUxState(this.expenseList);
}

class TransactionInitialState extends TransactionUxState {
  final SlideState? slideState;
  final DataState? dataState;
  final ImageDataState? imageDataState;
  final ExpenseEntity? selectExpense;
  final Map<int, List<ExpenseEntity>>? expenseOfDayMap;

  TransactionInitialState({
    List<ExpenseEntity>? expenseList,
    this.slideState,
    this.dataState,
    this.expenseOfDayMap,
    this.imageDataState = ImageDataState.loading,
    this.selectExpense,
  }) : super(expenseList);

  TransactionInitialState update({
    List<ExpenseEntity>? expenseList,
    DataState? dataState,
    SlideState? slideState,
    ImageDataState? imageDataState,
    ExpenseEntity? selectExpense,
    Map<int, List<ExpenseEntity>>? expenseOfDayMap,
  }) {
    final TransactionInitialState state = TransactionInitialState(
      expenseList: expenseList ?? this.expenseList,
      dataState: dataState ?? this.dataState,
      slideState: slideState ?? this.slideState,
      imageDataState: imageDataState ?? this.imageDataState,
      expenseOfDayMap: expenseOfDayMap ?? this.expenseOfDayMap,
      selectExpense: selectExpense ?? this.selectExpense,
    );
    return state;
  }

  @override
  List<Object?> get props => [
        expenseList,
        selectExpense,
        imageDataState,
        selectExpense,
        dataState,
      ];
}

class TransactionLoadingState extends TransactionUxState {
  TransactionLoadingState({List<ExpenseEntity>? expenseList})
      : super(expenseList!);

  @override
  List<Object> get props => [];
}
