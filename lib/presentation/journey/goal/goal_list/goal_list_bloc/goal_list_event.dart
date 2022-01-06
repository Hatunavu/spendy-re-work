part of 'goal_list_bloc.dart';

abstract class GoalListEvent extends Equatable {
  const GoalListEvent();
}

class GoalListInitialEvent extends GoalListEvent {
  @override
  List<Object> get props => [];
}

class FetchGoalList extends GoalListEvent {
  final List<GoalEntity> goalList;

  FetchGoalList({required this.goalList});
  @override
  List<Object> get props => [goalList];
}

class AddAGoal extends GoalListEvent {
  final GoalDetailEntity goalDetailEntity;

  AddAGoal(this.goalDetailEntity);

  @override
  List<Object> get props => [goalDetailEntity];
}

class LoadMoreGoalsEvent extends GoalListEvent {
  @override
  List<Object> get props => [];
}

class SearchGoalEvent extends GoalListEvent {
  final String? keyword;

  SearchGoalEvent({this.keyword});

  @override
  List<Object?> get props => [keyword];
}

class ClearTextSearchEvent extends GoalListEvent {
  @override
  List<Object> get props => [];
}

class SearchTypingEvent extends GoalListEvent {
  final String keyword;
  SearchTypingEvent(this.keyword);
  @override
  List<Object> get props => [keyword];
}

class DeleteGoalEvent extends GoalListEvent {
  final GoalEntity goal;

  DeleteGoalEvent(this.goal);
  @override
  List<Object> get props => [goal];
}

class OpenGoalSlideEvent extends GoalListEvent {
  final GoalEntity goal;

  OpenGoalSlideEvent(this.goal);

  @override
  List<Object> get props => [];
}

class CloseGoalSlideEvent extends GoalListEvent {
  @override
  List<Object> get props => [];
}
