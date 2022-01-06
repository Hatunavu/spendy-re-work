import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/firebase_storage_constants.dart';
import 'package:spendy_re_work/common/constants/key_constants.dart';
import 'package:spendy_re_work/domain/entities/category_entity.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/entities/filter/date_filter_entity.dart';
import 'package:spendy_re_work/domain/entities/filter/expense_range_entity.dart';
import 'package:spendy_re_work/domain/entities/filter/filter.dart';
import 'package:spendy_re_work/domain/usecases/categories_usecase.dart';
import 'package:spendy_re_work/domain/usecases/date_usecase.dart';
import 'package:spendy_re_work/domain/usecases/filter_usecase.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_constants.dart';

import 'filter_event.dart';
import 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final CategoriesUseCase categoriesUseCase;
  final DateUseCase dateUseCase;
  final FilterUseCase filterUseCase;
  final AuthenticationBloc authBloc;

  FilterBloc({
    required this.categoriesUseCase,
    required this.dateUseCase,
    required this.filterUseCase,
    required this.authBloc,
  }) : super(FilterLoadingState());

  bool _isShowDeleteSelectCategory = false;
  bool _isShowDeleteSelectMonth = false;
  bool _isShowDeleteSelectGroup = false;
  bool _isShowDeselectedExpenseRange = false;
  bool _activeButton = false;
  bool _spendRangeInfinity = false;
  bool _changeExpenseRange = false;
  int _spendYear = 0;
  int _selectOptionTypeNumbers = 0;
  double _startExpenseRange = FilterConstants.minExpenseRange;
  double _endExpenseRange = FilterConstants.maxExpenseRange;
  String _selectCategory = '';
  String _selectMonth = '';
  String _selectGroup = '';
  late DateTime _minExpenseSpendTime;

  Map<String, CategoryEntity> _categoryMap = {};
  Map<String, DateFilter> _timerMap = {};

  @override
  Stream<FilterState> mapEventToState(FilterEvent event) async* {
    switch (event.runtimeType) {
      case FilterInitialEvent:
        yield* _mapFilterInitialMapToState(event as FilterInitialEvent);
        break;
      case SelectFilterEvent:
        yield* _mapSelectFilterEventToState(event as SelectFilterEvent);
        break;
      case ResetFilterEvent:
        yield* _mapResetFilterEventToState(event as ResetFilterEvent);
        break;
      case ApplyFilterEvent:
        yield* _mapApplyFilterEventToMap();
        break;
      case AddMoreSpendTimerEvent:
        yield* _mapAddMoreSpendTimerEventToState(event as AddMoreSpendTimerEvent);
        break;
    }
  }

  Stream<FilterState> _mapApplyFilterEventToMap() async* {
    // final List<String> categoryIds = await categoriesUseCase.getAllCategoryIds(
    //     _categoryMap, _selectCategorySet.toList());
    final DateFilter? dateFilter = await filterUseCase.getDateFilter(_timerMap, _selectMonth);
    final currentState = state;

    // final List<int> groupFilters =
    //     await filterUseCase.getGroupFilter(_selectGroupParticipantSet.toList());
    ExpenseRange expenseRangeEntity = ExpenseRange.toDefault();
    if (_changeExpenseRange) {
      if (_spendRangeInfinity == true && _endExpenseRange == FilterConstants.maxExpenseRange) {
        expenseRangeEntity =
            ExpenseRange(start: _startExpenseRange.ceil(), end: FilterConstants.lastRangeInfinity);
      } else {
        expenseRangeEntity =
            ExpenseRange(start: _startExpenseRange.ceil(), end: _endExpenseRange.ceil());
      }
    }
    // HARD CORE
    yield ApplyFilterState(
        filter: Filter(
      category: _selectCategory,
      dateFilter: dateFilter,
      // groupFilters: groupFilters,
      range: expenseRangeEntity,
    ));
    yield currentState;
  }

  /// ===== RESET FILTER =====
  Stream<FilterState> _mapResetFilterEventToState(ResetFilterEvent event) async* {
    //final currentState = state;
    if (event.optionKey == KeyConstants.categoryFilterOptionKey) {
      _selectCategory = '';
      _isShowDeleteSelectCategory = false;
    } else if (event.optionKey == KeyConstants.monthFilterOptionKey) {
      _selectMonth = '';
      _isShowDeleteSelectMonth = false;
    } else if (event.optionKey == KeyConstants.groupFilterOptionKey) {
      _selectGroup = '';
      _isShowDeleteSelectGroup = false;
    } else if (event.optionKey == KeyConstants.expenseRangeFilterOptionKey) {
      _startExpenseRange = FilterConstants.minExpenseRange;
      _endExpenseRange = FilterConstants.maxExpenseRange;
      _spendRangeInfinity = false;
      _isShowDeselectedExpenseRange = false;
    } else {
      _selectCategory = '';
      _selectMonth = '';
      _selectGroup = '';
      _startExpenseRange = FilterConstants.minExpenseRange;
      _endExpenseRange = FilterConstants.maxExpenseRange;

      _isShowDeleteSelectCategory = false;
      _isShowDeleteSelectMonth = false;
      _isShowDeleteSelectGroup = false;
      _isShowDeselectedExpenseRange = false;
    }
    await _update();
    yield FilterInitialState(
        categoryNameList: _categoryMap.keys.toList(),
        monthList: _timerMap.keys.toList(),
        selectCategory: _selectCategory,
        selectMonth: _selectMonth,
        selectGroup: _selectGroup,
        startExpenseRange: _startExpenseRange,
        endExpenseRange: _endExpenseRange,
        selectOptionTypeNumbers: _selectOptionTypeNumbers,
        isShowDeleteSelectCategory: _isShowDeleteSelectCategory,
        isShowDeleteSelectMonth: _isShowDeleteSelectMonth,
        isShowDeleteSelectGroup: _isShowDeleteSelectGroup,
        iShowDeselectedExpenseRange: _isShowDeselectedExpenseRange,
        isActiveButton: _activeButton,
        spendRangeInfinity: _spendRangeInfinity,
        isShowMore: _spendYear > _minExpenseSpendTime.year,

        ///BE CAREFUL APPLY
        apply: true);
  }

  /// ===== SELECT FILTER =====
  Stream<FilterState> _mapSelectFilterEventToState(SelectFilterEvent event) async* {
    yield SelectFilterState();
    if (event.optionKey != KeyConstants.expenseRangeFilterOptionKey) {
      await _selectOption(
          selectOption: event.selectOption!, active: event.active!, optionKey: event.optionKey!);
    } else //(event.optionKey == KeyConstants.expenseRangeFilterOptionKey)
    {
      await _selectExpenseRange(
          startRange: event.startRange!,
          endRange: event.endRange!,
          infinity: event.spendRangeInfinity!);
    }
    await _update();
    yield FilterInitialState(
        selectOptionTypeNumbers: _selectOptionTypeNumbers,
        categoryNameList: _categoryMap.keys.toList(),
        monthList: _timerMap.keys.toList(),
        selectCategory: _selectCategory,
        selectMonth: _selectMonth,
        selectGroup: _selectGroup,
        startExpenseRange: _startExpenseRange,
        endExpenseRange: _endExpenseRange,
        isShowDeleteSelectCategory: _isShowDeleteSelectCategory,
        isShowDeleteSelectMonth: _isShowDeleteSelectMonth,
        isShowDeleteSelectGroup: _isShowDeleteSelectGroup,
        iShowDeselectedExpenseRange: _isShowDeselectedExpenseRange,
        isActiveButton: _activeButton,
        spendRangeInfinity: _spendRangeInfinity,
        isShowMore: _spendYear > _minExpenseSpendTime.year,

        ///BE CAREFUL APPLY
        apply: true);
  }

  Future<void> _selectOption({String? selectOption, bool? active, String? optionKey}) async {
    if (selectOption != null && selectOption.isNotEmpty) {
      if (optionKey == KeyConstants.categoryFilterOptionKey) {
        if (active!) {
          _selectCategory = selectOption;
          _isShowDeleteSelectCategory = true;
        } else {
          _selectCategory = '';
          _isShowDeleteSelectCategory = false;
        }
      } else if (optionKey == KeyConstants.monthFilterOptionKey) {
        if (active!) {
          _selectMonth = selectOption;
          _isShowDeleteSelectMonth = true;
        } else {
          _selectMonth = '';
          _isShowDeleteSelectMonth = false;
        }
      } else if (optionKey == KeyConstants.groupFilterOptionKey) {
        if (active!) {
          _selectGroup = selectOption;
          _isShowDeleteSelectGroup = true;
        } else {
          selectOption = '';
          _isShowDeleteSelectGroup = false;
        }
      }
    }
  }

  Future<void> _selectExpenseRange({double? startRange, double? endRange, bool? infinity}) async {
    _changeExpenseRange = true;
    if (endRange != FilterConstants.maxExpenseRange && infinity!) {
      _spendRangeInfinity = true;
    }
    if (startRange != null) {
      _startExpenseRange = startRange;
    }
    if (endRange != null) {
      _endExpenseRange = endRange;
    }
    if (_startExpenseRange == FilterConstants.minExpenseRange &&
        _endExpenseRange == FilterConstants.maxExpenseRange &&
        !_spendRangeInfinity) {
      _isShowDeselectedExpenseRange = false;
    } else {
      _isShowDeselectedExpenseRange = true;
    }
  }

  /// ===== FILTER INITIAL =====
  Stream<FilterState> _mapFilterInitialMapToState(FilterInitialEvent event) async* {
    yield FilterLoadingState();
    await _setCategoryList();
    _spendYear = DateTime.now().year;
    _timerMap.clear();
    final ExpenseEntity minTimeExpense =
        await filterUseCase.getExpenseWithSpendTime(authBloc.userEntity.uid!, false);
    _minExpenseSpendTime = DateTime.fromMillisecondsSinceEpoch(minTimeExpense.spendTime);
    _timerMap =
        await dateUseCase.getAllMonths(_spendYear, event.languageCode!, _minExpenseSpendTime);
    yield FilterInitialState(
      selectOptionTypeNumbers: _selectOptionTypeNumbers,
      categoryNameList: _categoryMap.keys.toList(),
      monthList: _timerMap.keys.toList(),
      startExpenseRange: _startExpenseRange,
      endExpenseRange: _endExpenseRange,
      isShowDeleteSelectCategory: false,
      isShowDeleteSelectMonth: false,
      isShowDeleteSelectGroup: false,
      iShowDeselectedExpenseRange: false,
      isActiveButton: false,
      isShowMore: _spendYear > _minExpenseSpendTime.year,
      spendRangeInfinity: _spendRangeInfinity,

      ///BE CAREFUL APPLY
      apply: true,
    );
  }

  Future<void> _setCategoryList() async {
    if (authBloc.categoryList.isEmpty) {
      authBloc.categoryList = await categoriesUseCase.getCategoryListCate(
          authBloc.userEntity.uid!, FirebaseStorageConstants.transactionType);
    }
    final List<CategoryEntity> categories = authBloc.categoryList;
    _categoryMap = await categoriesUseCase.addCategoryToMap(categories: categories);
  }

  Future<void> _update() async {
    _selectOptionTypeNumbers = await filterUseCase.getSelectOptionTypeNumbers(
      category: _selectCategory,
      month: _selectMonth,
      group: _selectGroup,
      startRange: _startExpenseRange,
      endRange: _endExpenseRange,
    );
    _activeButton = await filterUseCase.checkActiveButton(
      category: _selectCategory,
      month: _selectMonth,
      group: _selectGroup,
      startRange: _startExpenseRange,
      endRange: _endExpenseRange,
      infinitySpendRange: _spendRangeInfinity,
    );
  }

  Stream<FilterState> _mapAddMoreSpendTimerEventToState(AddMoreSpendTimerEvent event) async* {
    final currentState = state;
    if (currentState is FilterInitialState) {
      _spendYear--;
      final Map<String, DateFilter> timerMap =
          await dateUseCase.getAllMonths(_spendYear, event.languageCode!, _minExpenseSpendTime);
      _timerMap.addAll(timerMap);
      yield currentState.copyWith(
        isShowMore: _spendYear > _minExpenseSpendTime.year,
        monthList: _timerMap.keys.toList(),
      );
    }
  }
}
