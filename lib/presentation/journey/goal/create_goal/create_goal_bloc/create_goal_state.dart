part of 'create_goal_bloc.dart';

abstract class CreateGoalState extends Equatable {
  const CreateGoalState();
}

class CreateGoalInitial extends CreateGoalState {
  @override
  List<Object> get props => [];
}

class CreateGoalLoading extends CreateGoalState {
  @override
  List<Object> get props => [];
}

class CreateGoalSuccess extends CreateGoalState {
  final GoalEntity goalEntity;
  final CategoryEntity categoryEntity;

  CreateGoalSuccess(this.goalEntity, this.categoryEntity);

  @override
  List<Object> get props => [categoryEntity, goalEntity];
}

class CreateGoalFailed extends CreateGoalState {
  @override
  List<Object> get props => [];
}

class CreateGoalLoadDataFailed extends CreateGoalState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class CreateGoalInitializedData extends CreateGoalState {
  final List<CategoryEntity>? categories;
  final CategoryEntity? category;
  final double? amountOfTime;
  final int? amountPerMonth;
  final bool? isGoalAchieved;
  final CurrencyEntity? currencyEntity;
  final String? nameGoal;
  final String? note;
  final String? money;
  final GoalDurationType? durationType;
  final DateTime? date;
  final DataState? crudState;
  final int? expiredDate;
  final bool? isValidate;

  CreateGoalInitializedData(
      {this.categories,
      this.durationType,
      this.currencyEntity,
      this.nameGoal,
      this.note,
      this.money,
      this.category,
      this.date,
      this.amountOfTime,
      this.isGoalAchieved,
      this.isValidate,
      this.amountPerMonth,
      this.crudState,
      this.expiredDate});

  CreateGoalInitializedData copyWith(
      {List<CategoryEntity>? categories,
      CategoryEntity? cateSelected,
      CurrencyEntity? currencyEntity,
      DateTime? date,
      double? amountOfTime,
      bool? isGoalAchieved,
      int? amountPerMonth,
      String? nameGoal,
      String? note,
      String? money,
      bool? isValidate,
      GoalDurationType? durationType,
      DataState? crudState,
      int? expiredDate}) {
    return CreateGoalInitializedData(
        money: money ?? this.money,
        nameGoal: nameGoal ?? this.nameGoal,
        note: note ?? this.note,
        currencyEntity: currencyEntity ?? this.currencyEntity,
        category: cateSelected ?? category,
        amountOfTime: amountOfTime ?? this.amountOfTime,
        amountPerMonth: amountPerMonth ?? this.amountPerMonth,
        categories: categories ?? this.categories,
        isValidate: isValidate ?? this.isValidate,
        isGoalAchieved: isGoalAchieved ?? this.isGoalAchieved,
        date: date ?? this.date,
        durationType: durationType ?? this.durationType,
        crudState: crudState ?? this.crudState,
        expiredDate: expiredDate ?? this.expiredDate);
  }

  @override
  List<Object?> get props => [
        categories,
        money,
        nameGoal,
        note,
        currencyEntity,
        category,
        date,
        amountPerMonth,
        amountOfTime,
        isGoalAchieved,
        isValidate,
        durationType,
        crudState,
        expiredDate
      ];
}
