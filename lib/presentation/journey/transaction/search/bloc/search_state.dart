import 'package:spendy_re_work/common/constants/image_data_state.dart';
import 'package:spendy_re_work/common/enums/data_state.dart';
import 'package:spendy_re_work/common/enums/slide_state.dart';
import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';

class SearchState extends Equatable {
  final SlideState? slideState;
  final DataState? dataState;
  final ImageDataState? imageDataState;
  final ExpenseEntity? selectedExpense;
  final Map<int, List<ExpenseEntity>>? searchResultMap;
  final Map<String, String>? categoryNameMap;
  final List<ExpenseEntity>? recentlyList;
  final bool? searchSuccess;
  final bool? showButtonClear;
  final bool? clearSearchField;
  final bool? isLoading;
  final bool? loadMore;
  final bool? internetConnected;

  SearchState(
      {List<ExpenseEntity>? expenseList,
      this.dataState,
      this.slideState,
      this.imageDataState,
      this.recentlyList,
      this.categoryNameMap,
      this.searchResultMap,
      this.selectedExpense,
      this.searchSuccess,
      this.clearSearchField,
      this.showButtonClear,
      this.isLoading,
      this.loadMore,
      this.internetConnected});

  factory SearchState.init() {
    return SearchState(
      slideState: SlideState.none,
      dataState: DataState.none,
      imageDataState: ImageDataState.none,
      selectedExpense: ExpenseEntity.normal(),
      categoryNameMap: const {},
      searchResultMap: const {},
      recentlyList: const [],
      searchSuccess: false,
      clearSearchField: false,
      showButtonClear: false,
      isLoading: false,
      loadMore: false,
      internetConnected: true,
    );
  }

  SearchState update(
      {SlideState? slideState,
      DataState? dataState,
      ExpenseEntity? selectedExpense,
      Map<String, String>? categoryNameMap,
      Map<int, List<ExpenseEntity>>? searchResultMap,
      List<ExpenseEntity>? recentlyList,
      bool? searchSuccess,
      bool? clearSearchField,
      bool? showButtonClear,
      bool? isLoading,
      bool? loadMore,
      ImageDataState? imageDataState,
      bool? internetConnected}) {
    return SearchState(
        slideState: slideState ?? this.slideState,
        dataState: dataState ?? this.dataState,
        imageDataState: imageDataState ?? this.imageDataState,
        selectedExpense: selectedExpense ?? this.selectedExpense,
        categoryNameMap: categoryNameMap ?? this.categoryNameMap,
        searchResultMap: searchResultMap ?? this.searchResultMap,
        recentlyList: recentlyList ?? this.recentlyList,
        searchSuccess: searchSuccess ?? this.searchSuccess,
        showButtonClear: showButtonClear ?? this.showButtonClear,
        clearSearchField: clearSearchField ?? this.clearSearchField,
        isLoading: isLoading ?? this.isLoading,
        loadMore: loadMore ?? this.loadMore,
        internetConnected: internetConnected ?? this.internetConnected);
  }

  @override
  List<Object?> get props => [
        slideState,
        dataState,
        imageDataState,
        selectedExpense,
        searchResultMap,
        recentlyList,
        searchSuccess,
        showButtonClear,
        clearSearchField,
        isLoading,
        categoryNameMap,
        loadMore,
        internetConnected
      ];
}
