import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spendy_re_work/common/constants/goal_contants.dart';
import 'package:spendy_re_work/common/enums/data_state.dart';
import 'package:spendy_re_work/common/enums/slide_state.dart';
import 'package:spendy_re_work/domain/entities/currency_entity.dart';
import 'package:spendy_re_work/domain/entities/goal_detail_entity.dart';
import 'package:spendy_re_work/domain/entities/goal_entity.dart';
import 'package:spendy_re_work/domain/entities/user/user_entity.dart';
import 'package:spendy_re_work/domain/usecases/currency_usecase.dart';
import 'package:spendy_re_work/domain/usecases/goal_usecase.dart';
import 'package:spendy_re_work/domain/usecases/search_usecase.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/bloc/loader_bloc/bloc.dart';
import 'package:spendy_re_work/presentation/bloc/loader_bloc/loader_bloc.dart';
import 'package:spendy_re_work/presentation/journey/home/notification/noti_bloc.dart';
import 'package:spendy_re_work/presentation/journey/home/notification/noti_event.dart';

part 'goal_list_event.dart';

part 'goal_list_state.dart';

class GoalListBloc extends Bloc<GoalListEvent, GoalListState> {
  final AuthenticationBloc authenticationBloc;
  final GoalUseCase goalUseCase;
  final CurrencyUseCase currencyUseCase;
  final SearchUseCase searchUseCase;
  final LoaderBloc loaderBloc;
  final NotificationBloc notificationBloc;

  List<GoalEntity>? _goalList = [];

  GoalListBloc(
      {required this.authenticationBloc,
      required this.goalUseCase,
      required this.currencyUseCase,
      required this.searchUseCase,
      required this.loaderBloc,
      required this.notificationBloc})
      : super(GoalListLoaded(
            dataState: DataState.none,
            goalSelected: GoalEntity.normal(),
            slideState: SlideState.none));

  UserEntity? _userEntity;
  CurrencyEntity? _currencyEntity;

  @override
  Stream<GoalListState> mapEventToState(
    GoalListEvent event,
  ) async* {
    switch (event.runtimeType) {
      case GoalListInitialEvent:
        {
          _listenGoalRequest();
          final currentState = state;
          if (currentState is GoalListLoaded) {
            yield currentState.copyWith(showButtonClear: false);
          }
        }
        break;
      case FetchGoalList:
        yield* _mapFetchGoalListToState(event as FetchGoalList);
        break;
      case LoadMoreGoalsEvent:
        _loadMoreGoals();
        break;
      case ClearTextSearchEvent:
        yield* _mapClearTextSearchEventToState(event as ClearTextSearchEvent);
        break;
      case SearchGoalEvent:
        yield* _mapSearchGoalEventToState(event as SearchGoalEvent);
        break;
      case SearchTypingEvent:
        yield* _mapSearchTypingEventToState(event as SearchTypingEvent);
        break;
      case DeleteGoalEvent:
        yield* _mapDeleteGoalEventToState(event as DeleteGoalEvent);
        break;
      case OpenGoalSlideEvent:
        yield* _mapOpenGoalSlideEventToState(event as OpenGoalSlideEvent);
        break;
      case CloseGoalSlideEvent:
        yield* _mapCloseGoalSlideEventToState(event as CloseGoalSlideEvent);
        break;
    }
  }

  Stream<GoalListState> _mapOpenGoalSlideEventToState(
      OpenGoalSlideEvent event) async* {
    final currentState = state;
    if (currentState is GoalListLoaded) {
      yield currentState.copyWith(
          slideState: SlideState.openSlide, goalSelected: event.goal);
    }
  }

  Stream<GoalListState> _mapCloseGoalSlideEventToState(
      CloseGoalSlideEvent event) async* {
    final currentState = state;
    if (currentState is GoalListLoaded) {
      yield currentState.copyWith(
          slideState: SlideState.closeSlide, goalSelected: GoalEntity.normal());
    }
  }

  Stream<GoalListState> _mapDeleteGoalEventToState(
      DeleteGoalEvent event) async* {
    loaderBloc.add(StartLoading());
    final user = authenticationBloc.userEntity;
    await goalUseCase.removeGoal(uid: user.uid, goalID: event.goal.id);
    notificationBloc.add(DeleteGoalNotiEvent(goalID: event.goal.id!));
    loaderBloc.add(FinishLoading());
  }

  Stream<GoalListState> _mapSearchTypingEventToState(
      SearchTypingEvent event) async* {
    final currentState = state;
    if (currentState is GoalListLoaded) {
      yield currentState.copyWith(
        showButtonClear: event.keyword.isNotEmpty,
      );
    }
    add(SearchGoalEvent(keyword: event.keyword));
  }

  Stream<GoalListState> _mapSearchGoalEventToState(
      SearchGoalEvent event) async* {
    if (event.keyword!.isEmpty) {
      add(GoalListInitialEvent());
    } else {
      final goals = await searchUseCase.searchGoal(
          keyword: event.keyword, goals: _goalList);
      final List<GoalEntity> goalList = [];
      for (final GoalEntity goal in goals) {
        goal.percentProgress = goalUseCase.getPercentProgress(
            date: goal.date,
            today: DateTime.now().millisecondsSinceEpoch,
            durationType: goalDurationTypeMap[goal.duration]);
        goalList.add(goal);
      }
      final currentState = state;
      if (currentState is GoalListLoaded) {
        yield currentState.copyWith(goals: goalList, showButtonClear: true);
      }
    }
  }

  Stream<GoalListState> _mapClearTextSearchEventToState(
      ClearTextSearchEvent event) async* {
    final currentState = state;
    if (currentState is GoalListLoaded) {
      yield currentState.copyWith(showButtonClear: false);
    }
    add(GoalListInitialEvent());
  }

  Stream<GoalListState> _mapFetchGoalListToState(FetchGoalList event) async* {
    try {
      _goalList = [];
      final List<GoalEntity> goalListData = event.goalList;
      final categoryList = authenticationBloc.goalCategory;
      final categoryNameMap =
          await searchUseCase.getMapCategory(categories: categoryList);
      final currentState = state;
      _currencyEntity ??= await currencyUseCase.getCurrentCurrency();
      if (currentState is GoalListLoaded) {
        if (currentState.dataState == DataState.none) {
          yield currentState.copyWith(dataState: DataState.loading);
        } else if (currentState.dataState == DataState.success) {
          yield currentState.copyWith(dataState: DataState.loadingMore);
        }
        for (final GoalEntity goalData in goalListData) {
          if (!goalData.achieved!) {
            goalData.percentProgress = goalUseCase.getPercentProgress(
                date: goalData.date,
                today: DateTime.now().millisecondsSinceEpoch,
                durationType: goalDurationTypeMap[goalData.duration]);
            _goalList?.add(goalData);
          }
        }
        yield GoalListLoaded(
            goals: _goalList!,
            dataState: DataState.success,
            currency: _currencyEntity!.code!,
            hasMore: goalUseCase.hasMore,
            categoryNameMap: categoryNameMap,
            showButtonClear: false);
      }
    } catch (e) {
      yield GoalListFailure();
    }
  }

  void _listenGoalRequest() {
    //print('_listenGoalRequest');
    _userEntity = authenticationBloc.userEntity;
    //print('uid : ${_userEntity?.uid}');
    goalUseCase.listenGoalsRequest(uid: _userEntity?.uid).listen((goalData) {
      // print('listen goal request :');
      //print('goal data : $goalData');
      add(FetchGoalList(goalList: goalData));
    });
  }

  void _loadMoreGoals() {
    goalUseCase.loadMoreGoals(uid: _userEntity?.uid);
  }
}
