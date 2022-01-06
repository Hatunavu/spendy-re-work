part of 'home_chart_data_bloc.dart';

abstract class HomeChartDataState extends Equatable {
  final Map<int, int>? reportWeekMap;
  final Map<int, int>? reportDailyMap;
  final Map<int, int>? reportMonthlyMap;
  final DataState? dataState;

  const HomeChartDataState(
      {this.reportDailyMap,
      this.reportWeekMap,
      this.reportMonthlyMap,
      this.dataState});

  @override
  List<Object?> get props =>
      [reportDailyMap, reportWeekMap, reportMonthlyMap, dataState];
}

class HomeChartDataLoaded extends HomeChartDataState {
  final bool? isCurrent;
  final int? totalAmount;

  HomeChartDataLoaded({
    this.isCurrent = true,
    DataState? dataState = DataState.none,
    Map<int, int>? reportDailyMap,
    this.totalAmount = 0,
    Map<int, int>? reportWeekMap,
    Map<int, int>? reportMonthlyMap,
  }) : super(
            reportDailyMap: reportDailyMap,
            reportWeekMap: reportWeekMap,
            reportMonthlyMap: reportMonthlyMap,
            dataState: dataState);

  HomeChartDataLoaded copyWith(
      {int? totalAmount,
      DataState? dataState,
      Map<int, int>? reportDailyMap,
      Map<int, int>? reportWeekMap,
      Map<int, int>? reportMonthlyMap}) {
    return HomeChartDataLoaded(
      reportDailyMap: reportDailyMap ?? this.reportDailyMap,
      dataState: dataState ?? this.dataState,
      isCurrent: !isCurrent!,
      totalAmount: totalAmount ?? this.totalAmount,
      reportWeekMap: reportWeekMap ?? this.reportWeekMap,
      reportMonthlyMap: reportMonthlyMap ?? this.reportMonthlyMap,
    );
  }

  @override
  List<Object?> get props => super.props..addAll([isCurrent, totalAmount]);
}

class HomeChartDataFailure extends HomeChartDataState {
  final Exception? exception;

  HomeChartDataFailure({this.exception});

  @override
  List<Object?> get props => [exception];
}
