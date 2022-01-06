import 'package:spendy_re_work/common/enums/data_state.dart';
import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/domain/usecases/report_usecase.dart';

abstract class ReportDataState extends Equatable {}

class ReportChartLoadingState extends ReportDataState {
  @override
  List<Object> get props => [];
}

class ReportChartInitialState extends ReportDataState {
  final DataState? dataState;
  final Map<int, int>? totalAmountOfMonthMap;
  final Map<int, int>? totalAmountOfDayMap;
  final ReportOfMonth? reportOfMonth;
  final bool emptyDataChart;
  final DateTime? selectedTime;

  ReportChartInitialState(
      {this.totalAmountOfMonthMap,
      this.totalAmountOfDayMap,
      this.dataState,
      this.reportOfMonth,
      this.emptyDataChart = true,
      this.selectedTime});

  factory ReportChartInitialState.init() {
    final Map<int, int> totalAmountOfMonthMap = Map();
    for (int i = 1; i <= 12; i++) {
      totalAmountOfMonthMap[i] = 0;
    }
    final Map<int, int> totalAmountOfDayMap = Map();
    for (int i = 1; i <= DateTime.now().day; i++) {
      totalAmountOfDayMap[i] = 0;
    }

    return ReportChartInitialState(
        dataState: DataState.none,
        totalAmountOfMonthMap: totalAmountOfMonthMap,
        totalAmountOfDayMap: totalAmountOfDayMap,
        reportOfMonth: null,
        emptyDataChart: true,
        selectedTime: DateTime.now());
  }

  @override
  List<Object?> get props => [
        totalAmountOfMonthMap,
        totalAmountOfDayMap,
        dataState,
        reportOfMonth,
        emptyDataChart,
        selectedTime
      ];

  ReportChartInitialState copyWith({
    DataState? dataState,
    Map<int, int>? totalAmountOfMonthMap,
    Map<int, int>? totalAmountOfDayMap,
    int? totalExpense,
    ReportOfMonth? reportOfMonth,
    DateTime? selectedTime,
    bool? emptyDataChart,
  }) =>
      ReportChartInitialState(
        dataState: dataState ?? this.dataState,
        totalAmountOfMonthMap:
            totalAmountOfMonthMap ?? this.totalAmountOfMonthMap,
        totalAmountOfDayMap: totalAmountOfDayMap ?? this.totalAmountOfDayMap,
        reportOfMonth: reportOfMonth ?? this.reportOfMonth,
        emptyDataChart: emptyDataChart ?? this.emptyDataChart,
        selectedTime: selectedTime ?? this.selectedTime,
      );
}

class ReportChartRefreshState extends ReportDataState {
  final DateTime selectedTime;

  ReportChartRefreshState(this.selectedTime);

  @override
  List<Object> get props => [selectedTime];
}
