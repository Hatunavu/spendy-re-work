import 'package:spendy_re_work/common/constants/image_data_state.dart';
import 'package:spendy_re_work/common/enums/data_state.dart';
import 'package:spendy_re_work/common/enums/slide_state.dart';
import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';

abstract class FilterResultState extends Equatable {}

class FilterResultInitialState extends FilterResultState {
  final List<ExpenseEntity> expenseList;
  final Map<String, String> tagMap;
  final DataState dataState;
  final bool loadMore;
  final SlideState slideState;
  final ImageDataState imageDataState;
  final ExpenseEntity? selectExpense;

  FilterResultInitialState({
    required this.expenseList,
    required this.tagMap,
    required this.loadMore,
    required this.dataState,
    required this.slideState,
    this.imageDataState = ImageDataState.loading,
    this.selectExpense,
  });

  FilterResultInitialState copyWith({
    List<ExpenseEntity>? expenseList,
    Map<String, String>? tagMap,
    DataState? dataState,
    bool? loadMore,
    SlideState? slideState,
    ImageDataState? imageDataState,
    ExpenseEntity? selectExpense,
  }) =>
      FilterResultInitialState(
        expenseList: expenseList ?? this.expenseList,
        tagMap: tagMap ?? this.tagMap,
        loadMore: loadMore ?? this.loadMore,
        dataState: dataState ?? this.dataState,
        slideState: slideState ?? this.slideState,
        imageDataState: imageDataState ?? this.imageDataState,
        selectExpense: selectExpense ?? this.selectExpense,
      );

  @override
  List<Object> get props => [
        expenseList,
        tagMap,
        loadMore,
        dataState,
        slideState,
        imageDataState,
        selectExpense!,
      ];
}
