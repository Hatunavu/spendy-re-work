part of 'home_chart_bloc.dart';

abstract class HomeChartEvent extends Equatable {
  const HomeChartEvent();
}

class ChangeExpenseTypeData extends HomeChartEvent {
  final ColumnChartValueTypeEnum typeName;

  ChangeExpenseTypeData(this.typeName);

  @override
  List<Object> get props => [typeName];
}

class ChangeOwedTypeData extends HomeChartEvent {
  final ColumnChartValueTypeEnum typeName;

  ChangeOwedTypeData(this.typeName);

  @override
  List<Object> get props => [typeName];
}
