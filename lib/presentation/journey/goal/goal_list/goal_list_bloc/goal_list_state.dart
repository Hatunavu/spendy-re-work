part of 'goal_list_bloc.dart';

abstract class GoalListState extends Equatable {
  final bool showButtonClear;
  final Map<String, String>? categoryNameMap;

  const GoalListState({this.showButtonClear = false, this.categoryNameMap});
}

class GoalListInitial extends GoalListState {
  @override
  List<Object> get props => [];
}

class GoalListLoaded extends GoalListState {
  final List<GoalEntity>? goals;
  final String? currency;
  final bool? hasMore;
  final bool? isCurrent;
  final DataState? dataState;
  final SlideState? slideState;
  final GoalEntity? goalSelected;

  GoalListLoaded(
      {this.goals,
      this.hasMore,
      this.currency,
      this.isCurrent = true,
      this.dataState,
      this.slideState,
      this.goalSelected,
      Map<String, String>? categoryNameMap,
      bool showButtonClear = false})
      : super(
            showButtonClear: showButtonClear, categoryNameMap: categoryNameMap);

  GoalListLoaded copyWith(
      {List<GoalEntity>? goals,
      bool? hasMore,
      DataState? dataState,
      Map<String, String>? categoryNameMap,
      bool? showButtonClear,
      SlideState? slideState,
      GoalEntity? goalSelected}) {
    return GoalListLoaded(
        goals: goals ?? this.goals,
        hasMore: hasMore ?? this.hasMore,
        currency: currency,
        isCurrent: !isCurrent!,
        dataState: dataState ?? this.dataState,
        categoryNameMap: categoryNameMap ?? this.categoryNameMap,
        showButtonClear: showButtonClear ?? this.showButtonClear,
        slideState: slideState ?? this.slideState,
        goalSelected: goalSelected ?? this.goalSelected);
  }

  @override
  List<Object?> get props => [goals, hasMore, isCurrent, currency, dataState];
}

class GoalListLoading extends GoalListState {
  @override
  List<Object> get props => [];
}

class GoalListFailure extends GoalListState {
  @override
  List<Object> get props => [];
}
