import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/image_data_state.dart';
import 'package:spendy_re_work/common/enums/data_state.dart';
import 'package:spendy_re_work/common/enums/slide_state.dart';
import 'package:spendy_re_work/domain/entities/category_entity.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/entities/photo_entity.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';
import 'package:spendy_re_work/domain/usecases/search_usecase.dart';
import 'package:spendy_re_work/domain/usecases/transaction_use_case.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/search/bloc/search_event.dart';
import 'package:spendy_re_work/presentation/journey/transaction/search/bloc/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchUseCase searchUseCase;
  final AuthenticationBloc authenticationBloc;
  final TransactionUseCase transactionUseCase;

  SearchBloc({
    required this.searchUseCase,
    required this.authenticationBloc,
    required this.transactionUseCase,
  }) : super(SearchState.init());

  List<ExpenseEntity>? _recentList;
  List<ExpenseEntity>? _resultSearchList;
  List<CategoryEntity>? _categoryList;
  List<ExpenseEntity>? _allExpenses;
  bool _isUpdate = false;
  String? _searchKeyword;
  bool _isDelete = false;
  GroupEntity? _group;

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    switch (event.runtimeType) {
      case SearchInitialEvent:
        yield* _mapSearchInitEventToState(event as SearchInitialEvent);
        break;
      case SearchListenAllExpenseEvent:
        yield* _mapListenAllExpenseEventToState(
            event as SearchListenAllExpenseEvent);
        break;
      case SearchListenRecentEvent:
        yield* _mapListenRecentEventToState(event as SearchListenRecentEvent);
        break;
      case SearchExpenseEvent:
        yield* _mapSearchExpenseEventToState(event as SearchExpenseEvent);
        break;
      case OpenSlideSearchTransactionItemEvent:
        yield* _mapOpenSlideSearchTransactionItemEvent(
            event as OpenSlideSearchTransactionItemEvent);
        break;
      case CloseSlideSearchTransactionItemEvent:
        yield* _mapCloseSlideSearchTransactionItemEvent(event);
        break;
      case GetExpenseDetailEvent:
        yield* _mapGetExpenseDetailEventToState(event as GetExpenseDetailEvent);
        break;
      case TypingSearchFromEvent:
        yield* _mapTypingSearchFormEventToState(event as TypingSearchFromEvent);
        break;
      case CleanTextEvent:
        yield* _mapCleanTextEventToState(event as CleanTextEvent);
        break;
      case DeleteExpenseSearchEvent:
        yield* _mapDeleteExpenseSearchEventToState(
            event as DeleteExpenseSearchEvent);
        break;
      case UpdateSearchRecentlyEvent:
        yield* _mapUpdateSearchRecentlyEventToState(
            event as UpdateSearchRecentlyEvent);
        break;
      case LoadMoreEvent:
        yield* _mapLoadMoreEventToState(event as LoadMoreEvent);
        break;
    }
  }

  Stream<SearchState> _mapLoadMoreEventToState(LoadMoreEvent event) async* {
    yield state.update(dataState: DataState.loadingMore);
    final user = authenticationBloc.userEntity;
    searchUseCase.searchRequestMore(uid: user.uid, key: event.keyWord);
  }

  Stream<SearchState> _mapUpdateSearchRecentlyEventToState(
      UpdateSearchRecentlyEvent event) async* {
    _isUpdate = true;
    final user = authenticationBloc.userEntity;
    await transactionUseCase.updateSearchRecent(
        user.uid ?? '',
        _group?.id ?? '',
        event.expenseDetailEntity
            .copyWith(updateAt: DateTime.now().millisecondsSinceEpoch));
  }

  Stream<SearchState> _mapDeleteExpenseSearchEventToState(
      DeleteExpenseSearchEvent event) async* {
    yield state.update(isLoading: true);
    if (state.searchSuccess!) {
      _isDelete = true;
    }
    final user = authenticationBloc.userEntity;
    await transactionUseCase.deleteTransactionById(
        uid: user.uid!,
        transactionId: event.expenseDetail.id ?? '',
        groupId: _group?.id ?? '');
    yield state.update(isLoading: false);
  }

  Stream<SearchState> _mapCleanTextEventToState(CleanTextEvent event) async* {
    _isDelete = false;
    _isUpdate = false;
    yield state.update(
        clearSearchField: true, showButtonClear: false, searchSuccess: false);
    _listenRecentlyList();
  }

  Stream<SearchState> _mapTypingSearchFormEventToState(
      TypingSearchFromEvent event) async* {
    _searchKeyword = event.keyWord;
    if (event.keyWord.isNotEmpty) {
      yield state.update(
          showButtonClear: !event.keyWord.isEmpty, clearSearchField: false);
      add(SearchExpenseEvent(keyWord: event.keyWord));
    } else {
      _isUpdate = false;
      _isDelete = true;
      _listenRecentlyList();
    }
  }

  Stream<SearchState> _mapGetExpenseDetailEventToState(
      GetExpenseDetailEvent event) async* {
    yield state.update(
        imageDataState: ImageDataState.loading,
        slideState: SlideState.closeSlide,
        selectedExpense: event.expense);
    final List<PhotoEntity> photoList =
        await transactionUseCase.getImageUriRecentList(event.expense!.photos);
    event.expense!.copyWith(photos: photoList);
    if (event.isRecent!) {
      _recentList![event.index!] = event.expense!;
      yield state.update(
          imageDataState: ImageDataState.success,
          recentlyList: _recentList,
          selectedExpense: event.expense);
    } else {
      _resultSearchList![event.index!] = event.expense!;
      yield state.update(
          imageDataState: ImageDataState.success,
          recentlyList: _resultSearchList,
          selectedExpense: event.expense);
    }
  }

  Stream<SearchState> _mapCloseSlideSearchTransactionItemEvent(event) async* {
    yield state.update(
        slideState: SlideState.closeSlide,
        selectedExpense: ExpenseEntity.normal());
  }

  Stream<SearchState> _mapOpenSlideSearchTransactionItemEvent(
      OpenSlideSearchTransactionItemEvent event) async* {
    yield state.update(
        slideState: SlideState.openSlide,
        selectedExpense: event.selectExpenseDetail);
  }

  Stream<SearchState> _mapSearchInitEventToState(
      SearchInitialEvent event) async* {
    _isUpdate = false;
    _group = event.group;
    yield state.update(isLoading: true);
    _listenAllExpenses();
  }

  Stream<SearchState> _mapListenAllExpenseEventToState(
      SearchListenAllExpenseEvent event) async* {
    _allExpenses = [];
    _allExpenses!.addAll(event.expenses);
    _listenRecentlyList();
    yield* _handleSearchExpense();
  }

  Stream<SearchState> _mapListenRecentEventToState(
      SearchListenRecentEvent event) async* {
    _categoryList = [];
    _recentList = [];
    _recentList!.addAll(event.recentlyList!);
    _categoryList = authenticationBloc.categoryList;
    final Map<String, String> _categoryNameMap =
        await searchUseCase.getMapCategory(categories: _categoryList);
    if (!_isUpdate && !_isDelete) {
      _searchKeyword = '';
      yield state.update(
          clearSearchField: false,
          recentlyList: _recentList,
          categoryNameMap: _categoryNameMap,
          dataState: DataState.success,
          searchSuccess: false,
          showButtonClear: false,
          isLoading: false,
          internetConnected: true);
    } else {
      yield state.update(recentlyList: _recentList);
    }
  }

  Stream<SearchState> _mapSearchExpenseEventToState(
      SearchExpenseEvent event) async* {
    yield state.update(isLoading: true);

    if (event.keyWord.isEmpty) {
      yield state.update(
          searchSuccess: false,
          clearSearchField: false,
          internetConnected: true);
      _listenRecentlyList();
    } else {
      yield* _handleSearchExpense();
    }
  }

  void _resetBloc() {
    _recentList = [];
    _resultSearchList = [];
    _categoryList = [];
  }

  void _listenRecentlyList() {
    final user = authenticationBloc.userEntity;
    _resetBloc();
    searchUseCase
        .listenSearchRecently(user.uid ?? '', _group?.id ?? '')
        .listen((expenses) {
      final List<ExpenseEntity> expenseList = expenses;
      add(SearchListenRecentEvent(recentlyList: expenseList));
    });
  }

  void _listenAllExpenses() {
    final user = authenticationBloc.userEntity;
    searchUseCase
        .listenAllExpense(user.uid ?? '', _group?.id ?? '')
        .listen((expenses) {
      final List<ExpenseEntity> allExpenseList = expenses;
      add(SearchListenAllExpenseEvent(allExpenseList));
    });
  }

  Stream<SearchState> _handleSearchExpense() async* {
    final searchResult = await searchUseCase.searchExpense(
        keyword: _searchKeyword, allExpense: _allExpenses);
    _resultSearchList = [];
    _resultSearchList!.addAll(searchResult);
    final Map<int, List<ExpenseEntity>> _resultExpenseMap =
        await transactionUseCase.getExpenseByDayMapWithAds(_resultSearchList!);
    yield state.update(
        isLoading: false,
        searchResultMap: _resultExpenseMap,
        searchSuccess: true,
        dataState: DataState.success);
  }
}
