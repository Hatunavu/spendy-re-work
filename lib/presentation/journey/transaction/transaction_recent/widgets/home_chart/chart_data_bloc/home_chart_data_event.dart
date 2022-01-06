part of 'home_chart_data_bloc.dart';

abstract class HomeChartDataEvent extends Equatable {
  const HomeChartDataEvent();
}

class StreamHomeChartDataUpdate extends HomeChartDataEvent {
  final List<ExpenseEntity> expenseList;

  StreamHomeChartDataUpdate({required this.expenseList});

  @override
  List<Object> get props => [expenseList];
}

class ListenHomeChartDataEvent extends HomeChartDataEvent {
  @override
  List<Object> get props => [];
}

class PushErrorHomeChartData extends HomeChartDataEvent {
  final Object? e;

  PushErrorHomeChartData({this.e});

  @override
  List<Object?> get props => [e];
}
