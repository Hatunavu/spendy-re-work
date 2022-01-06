part of 'create_goal_bloc.dart';

abstract class CreateGoalEvent extends Equatable {
  const CreateGoalEvent();
}

class InitDataCreateGoalEvent extends CreateGoalEvent {
  final GoalEntity? goalEntity;

  InitDataCreateGoalEvent({this.goalEntity});

  @override
  List<Object?> get props => [goalEntity];
}

class CategoryChangeEvent extends CreateGoalEvent {
  final CategoryEntity selectCategory;

  CategoryChangeEvent(this.selectCategory);

  @override
  List<Object> get props => [selectCategory];
}

class GoalDurationChangeEvent extends CreateGoalEvent {
  final GoalDurationType durationType;

  GoalDurationChangeEvent(this.durationType);

  @override
  List<Object> get props => [durationType];
}

class MoneyChangeEvent extends CreateGoalEvent {
  final String money;

  MoneyChangeEvent(this.money);

  @override
  List<Object> get props => [money];
}

class GoalAchievedChangeEvent extends CreateGoalEvent {
  final bool isGoalAchieved;

  GoalAchievedChangeEvent(this.isGoalAchieved);

  @override
  List<Object> get props => [isGoalAchieved];
}

class GoalNameChangeEvent extends CreateGoalEvent {
  final String name;

  GoalNameChangeEvent(this.name);

  @override
  List<Object> get props => [name];
}

class NoteTextChangeEvent extends CreateGoalEvent {
  final String note;

  NoteTextChangeEvent(this.note);

  @override
  List<Object> get props => [note];
}

class OnPressedSaveEvent extends CreateGoalEvent {
  final bool isEdit;

  OnPressedSaveEvent({this.isEdit = false});

  @override
  List<Object> get props => [isEdit];
}

class OnPressedDeleteEvent extends CreateGoalEvent {
  final GoalEntity goalEntity;

  OnPressedDeleteEvent(this.goalEntity);

  @override
  List<Object> get props => [goalEntity];
}

class SelectDateEvent extends CreateGoalEvent {
  final DateTime date;

  SelectDateEvent({required this.date});
  @override
  List<Object> get props => [date];
}
