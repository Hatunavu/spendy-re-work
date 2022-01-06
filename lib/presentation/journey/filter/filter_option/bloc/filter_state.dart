import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/domain/entities/filter/filter.dart';

abstract class FilterState extends Equatable {}

class FilterLoadingState extends FilterState {
  @override
  List<Object> get props => [];
}

class FilterInitialState extends FilterState {
  final List<String> categoryNameList;
  final List<String> monthList;
  final String? selectCategory;
  final String? selectMonth;
  final String? selectGroup;
  final int selectOptionTypeNumbers;
  final double? startExpenseRange;
  final double? endExpenseRange;
  final bool isShowDeleteSelectCategory;
  final bool isShowDeleteSelectMonth;
  final bool isShowDeleteSelectGroup;
  final bool iShowDeselectedExpenseRange;
  final bool isActiveButton;
  final bool spendRangeInfinity;
  final bool apply;
  final bool isShowMore;

  FilterInitialState({
    required this.categoryNameList,
    required this.monthList,
    required this.isShowDeleteSelectCategory,
    required this.isShowDeleteSelectMonth,
    required this.isShowDeleteSelectGroup,
    required this.iShowDeselectedExpenseRange,
    required this.isActiveButton,
    required this.selectOptionTypeNumbers,
    required this.apply,
    this.selectCategory,
    this.selectMonth,
    this.selectGroup,
    this.startExpenseRange,
    this.endExpenseRange,
    this.spendRangeInfinity = false,
    this.isShowMore = false,
  });

  FilterInitialState copyWith(
          {List<String>? categoryNameList,
          List<String>? monthList,
          String? selectCategory,
          String? selectMonth,
          String? selectGroup,
          int? selectOptionTypeNumbers,
          double? startExpenseRange,
          double? endExpenseRange,
          bool? isShowDeleteSelectCategory,
          bool? isShowDeleteSelectMonth,
          bool? isShowDeleteSelectGroup,
          bool? iShowDeselectedExpenseRange,
          bool? isActiveButton,
          bool? spendRangeInfinity,
          bool? apply,
          bool? isShowMore}) =>
      FilterInitialState(
          categoryNameList: categoryNameList ?? this.categoryNameList,
          monthList: monthList ?? this.monthList,
          selectMonth: selectMonth ?? this.selectMonth,
          selectCategory: selectCategory ?? this.selectCategory,
          selectGroup: selectGroup ?? this.selectGroup,
          selectOptionTypeNumbers:
              selectOptionTypeNumbers ?? this.selectOptionTypeNumbers,
          startExpenseRange: startExpenseRange ?? this.startExpenseRange,
          endExpenseRange: endExpenseRange ?? this.endExpenseRange,
          isShowDeleteSelectCategory:
              isShowDeleteSelectCategory ?? this.isShowDeleteSelectCategory,
          isShowDeleteSelectMonth:
              isShowDeleteSelectMonth ?? this.isShowDeleteSelectMonth,
          isShowDeleteSelectGroup:
              isShowDeleteSelectGroup ?? this.isShowDeleteSelectGroup,
          apply: apply ?? this.apply,
          iShowDeselectedExpenseRange:
              iShowDeselectedExpenseRange ?? this.iShowDeselectedExpenseRange,
          isActiveButton: isActiveButton ?? this.isActiveButton,
          spendRangeInfinity: spendRangeInfinity ?? this.spendRangeInfinity,
          isShowMore: isShowMore ?? this.isShowMore);

  @override
  List<Object?> get props => [
        categoryNameList,
        monthList,
        isShowDeleteSelectMonth,
        isShowDeleteSelectCategory,
        isShowDeleteSelectGroup,
        iShowDeselectedExpenseRange,
        isActiveButton,
        selectOptionTypeNumbers,
        selectCategory,
        selectMonth,
        selectGroup,
        startExpenseRange,
        endExpenseRange,
        spendRangeInfinity,
        isShowMore
      ];
}

class SelectFilterState extends FilterState {
  @override
  List<Object> get props => [];
}

class ApplyFilterState extends FilterState {
  final Filter filter;

  ApplyFilterState({required this.filter});

  @override
  List<Object> get props => [filter];
}
