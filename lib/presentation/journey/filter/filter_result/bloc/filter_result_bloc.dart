import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/image_data_state.dart';
import 'package:spendy_re_work/common/enums/slide_state.dart';
import 'package:spendy_re_work/common/extensions/string_extensions.dart';
import 'package:spendy_re_work/common/extensions/date_time_extensions.dart';
import 'package:spendy_re_work/common/constants/category_name_map.dart';
import 'package:spendy_re_work/common/enums/data_state.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/entities/filter/expense_range_entity.dart';
import 'package:spendy_re_work/domain/entities/filter/filter.dart';
import 'package:spendy_re_work/domain/entities/photo_entity.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';
import 'package:spendy_re_work/domain/entities/user/user_entity.dart';
import 'package:spendy_re_work/domain/usecases/filter_usecase.dart';
import 'package:spendy_re_work/domain/usecases/transaction_use_case.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_constants.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_result/bloc/filter_result_state.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_result/bloc/fliter_result_event.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_result/filter_result_constants.dart';

class FilterResultBloc extends Bloc<FilterResultEvent, FilterResultState> {
  final FilterUseCase filterUseCase;
  final TransactionUseCase transactionUseCase;
  final AuthenticationBloc authBloc;

  late UserEntity _user;
  late Filter _filter;
  List<ExpenseEntity> _expenseList = [];
  GroupEntity? _group;

  FilterResultBloc({
    required this.filterUseCase,
    required this.transactionUseCase,
    required this.authBloc,
  }) : super(FilterResultInitialState(
            expenseList: const [],
            loadMore: false,
            dataState: DataState.none,
            tagMap: const {},
            selectExpense: ExpenseEntity.normal(),
            slideState: SlideState.openSlide));

  @override
  Stream<FilterResultState> mapEventToState(FilterResultEvent event) async* {
    if (event is ListenToFilter) {
      yield* _listenToFilter(event);
    }
    if (event is FilterResultInitialEvent) {
      yield* _mapFilterResultStateToState(event);
    }
    if (event is RemoveTagEvent) {
      yield* _mapRemoveTagEventToState(event);
    }
    if (event is OpenSlideEvent) {
      yield* _mapOpenSlideEventToState(event);
    }
    if (event is CloseSlideEvent) {
      yield* _mapCloseSlideEventToState();
    }
    if (event is DeleteExpenseEvent) {
      yield* _mapDeleteExpenseEventToState(event);
    }
    if (event is ShowTransactionDetailEvent) {
      yield* _mapShowTransactionDetailEventToState(event);
    }
    if (event is LoadMoreEvent) {
      final currentState = state;
      if (currentState is FilterResultInitialState) {
        yield currentState.copyWith(
          dataState: DataState.loadingMore,
        );
      }
      filterUseCase.loadMoreFilter(
          uid: _user.uid ?? '', groupId: _group?.id ?? '', filter: _filter);
    }
  }

  Stream<FilterResultState> _listenToFilter(ListenToFilter event) async* {
    _user = authBloc.userEntity;
    _filter = event.filter;
    _group = event.group;
    filterUseCase
        .listenToFilter(
            uid: _user.uid ?? '',
            groupId: _group?.id ?? '',
            filter: event.filter)
        .listen((expenseData) {
      add(FilterResultInitialEvent(
          expenseList: expenseData,
          filter: event.filter,
          languageCode: event.languageCode));
    });
  }

  Stream<FilterResultState> _mapFilterResultStateToState(
      FilterResultInitialEvent event) async* {
    final currentState = state;
    if (currentState is FilterResultInitialState) {
      yield currentState.copyWith(dataState: DataState.loading);
      _expenseList = await filterUseCase.fillAmount(
          expenseList: event.expenseList, filter: event.filter);
      _expenseList.sort((expenseA, expenseB) =>
          expenseB.spendTime.compareTo(expenseA.spendTime));
      final Map<String, String> tagMap =
          getTagMap(event.filter, languageCode: event.languageCode!);
      yield currentState.copyWith(
        expenseList: _expenseList,
        loadMore: false,
        tagMap: tagMap,
        dataState: DataState.success,
      );
    }
  }

  Map<String, String> getTagMap(Filter filter, {String? languageCode}) {
    final Map<String, String> tagMap = {};
    if (filter.isCategorySafe) {
      tagMap[FilterResultConstants.categoryKey] =
          CategoryCommon.categoryNameMap[filter.category]!;
    }
    if (filter.dateFilter != null && filter.dateFilter!.isSafe) {
      tagMap[FilterResultConstants.dateKey] =
          '${DateTime.fromMillisecondsSinceEpoch(filter.dateFilter!.start!).toStringMMMyyyy(languageCode!)}';
    }
    if (filter.range != null &&
        filter.range!.isSafe &&
        (filter.range!.start! > FilterConstants.minExpenseRange.toInt() ||
            filter.range!.end != FilterConstants.maxExpenseRange.toInt())) {
      tagMap[FilterResultConstants.rangeKey] =
          '${filter.range!.start.toString().formatStringToCurrency()} - ${filter.range!.end.toString().formatStringToCurrency()}';
    }
    return tagMap;
  }

  Stream<FilterResultState> _mapRemoveTagEventToState(
      RemoveTagEvent event) async* {
    if (event.key == FilterResultConstants.categoryKey) {
      _filter.category = '';
    } else if (event.key == FilterResultConstants.dateKey) {
      _filter.dateFilter = null;
    } else if (event.key == FilterResultConstants.rangeKey) {
      _filter.range = ExpenseRange.toDefault();
    }
    filterUseCase.renewFilter(
        uid: _user.uid ?? '', groupId: _group?.id ?? '', filter: _filter);
  }

  Stream<FilterResultState> _mapOpenSlideEventToState(
      OpenSlideEvent event) async* {
    final currentState = state;
    if (currentState is FilterResultInitialState) {
      yield currentState.copyWith(
          slideState: SlideState.openSlide, selectExpense: event.selectExpense);
    }
  }

  Stream<FilterResultState> _mapCloseSlideEventToState() async* {
    final currentState = state;

    if (currentState is FilterResultInitialState) {
      yield currentState.copyWith(
          slideState: SlideState.closeSlide,
          selectExpense: ExpenseEntity.normal());
    }
  }

  Stream<FilterResultState> _mapDeleteExpenseEventToState(
      DeleteExpenseEvent event) async* {
    final currentState = state;
    if (currentState is FilterResultInitialState) {
      yield currentState.copyWith(dataState: DataState.none);
    }
    await transactionUseCase.deleteTransactionById(
        uid: _user.uid ?? '',
        groupId: _group?.id ?? '',
        transactionId: event.expense.id ?? '');
  }

  Stream<FilterResultState> _mapShowTransactionDetailEventToState(
      ShowTransactionDetailEvent event) async* {
    final currentState = state;
    if (currentState is FilterResultInitialState) {
      yield currentState.copyWith(
        imageDataState: ImageDataState.loading,
        slideState: SlideState.closeSlide,
        selectExpense: event.selectExpense,
      );

      final List<PhotoEntity> photoList = await transactionUseCase
          .getImageUriRecentList(event.selectExpense.photos);
      event.selectExpense.copyWith(photos: photoList);
      _expenseList[event.selectIndex] = event.selectExpense;
      yield currentState.copyWith(
        imageDataState: ImageDataState.success,
        expenseList: _expenseList,
        selectExpense: event.selectExpense,
      );
    }
  }
}
