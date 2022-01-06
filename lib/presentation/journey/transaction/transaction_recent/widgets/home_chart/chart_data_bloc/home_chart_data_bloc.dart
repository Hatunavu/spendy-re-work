import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:spendy_re_work/common/enums/data_state.dart';
import 'package:spendy_re_work/common/extensions/date_time_extensions.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/usecases/report_usecase.dart';
import 'package:spendy_re_work/domain/usecases/settle_debt_usecase.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';

part 'home_chart_data_event.dart';

part 'home_chart_data_state.dart';

class HomeChartDataBloc extends Bloc<HomeChartDataEvent, HomeChartDataState> {
  final ReportUseCase reportUseCase;
  final AuthenticationBloc authBloc;
  final SettleDebtUseCase settleDebtUseCase;
  Map<int, int>? _reportWeekMap;
  Map<int, int>? _reportDailyMap;
  Map<int, int>? _reportMonthlyMap;
  List<DateTime>? _dateOfWeekList;
  List<DateTime>? _dateOfDailyList;
  List<DateTime>? _dateOfMonthlyList;
  StreamSubscription<Event>? _streamHomeChartData;

  final DateTime _now = DateTime.now();

  HomeChartDataBloc(
      {required this.reportUseCase,
      required this.authBloc,
      required this.settleDebtUseCase})
      : super(HomeChartDataLoaded(
          dataState: DataState.none,
          reportDailyMap: initialReportDataMap(
              startDay: DateTime.now().startOfWeek(),
              endDate: DateTime.now().endOfWeek()),
          reportWeekMap: initialReportDataMap(
              startDay: DateTime.now().startOfWeek(),
              endDate: DateTime.now().endOfWeek()),
          totalAmount: 0,
        )) {
    _reportWeekMap = initialReportDataMap(
        startDay: _now.startOfWeek(), endDate: _now.endOfWeek());
    _reportDailyMap = initialReportDataMap(
        startDay: _now.subDay(value: 6), endDate: _now.dateTimeYmd);
    _reportMonthlyMap = initialReportDataMap(
        startDay: DateTime(_now.year, _now.month, 1),
        endDate: DateTime(_now.year, _now.month + 1, 0));
  }

  @override
  Stream<HomeChartDataState> mapEventToState(
    HomeChartDataEvent event,
  ) async* {
    switch (event.runtimeType) {
      case ListenHomeChartDataEvent:
        {
          _listenToReportHomeDataRealTime();
        }
        break;
      case StreamHomeChartDataUpdate:
        yield* _mapStreamHomeChartDataUpdateToState(
            event as StreamHomeChartDataUpdate);
        break;
      case PushErrorHomeChartData:
        yield* _mapPushErrorHomeChartDataToState(
            event as PushErrorHomeChartData);
        break;
    }
  }

  /// call when logout
  Future resetBloc() async {
    _reportWeekMap = initialReportDataMap(
        startDay: _now.startOfWeek(), endDate: _now.endOfWeek());
    _reportDailyMap = initialReportDataMap(
        startDay: _now.subDay(value: 6), endDate: _now.dateTimeYmd);
    _reportMonthlyMap = initialReportDataMap(
        startDay: DateTime(_now.year, _now.month, 1),
        endDate: DateTime(_now.year, _now.month + 1, 0));

    _dateOfWeekList = initialDateList(
        startDay: _now.startOfWeek(), endDate: _now.endOfWeek());
    _dateOfDailyList = initialDateList(
        startDay: _now.subDay(value: 6), endDate: _now.dateTimeYmd);
    _dateOfMonthlyList = initialDateList(
        startDay: DateTime(_now.year, _now.month, 1),
        endDate: DateTime(_now.year, _now.month + 1, 0));
    if (_streamHomeChartData != null) {
      await _streamHomeChartData?.cancel();
    }
  }

  void _listenToReportHomeDataRealTime() {
    reportUseCase
        .listenToExpensesHomeReport(
            uid: authBloc.userEntity.uid,
            startDay: _now.firstDayOfYear,
            endDate: _now.lastDayOfYear)
        .listen((expenseList) {
      add(StreamHomeChartDataUpdate(expenseList: expenseList));
    }, onError: (Object error) => add(PushErrorHomeChartData(e: error)));
  }

  Stream<HomeChartDataState> _mapStreamHomeChartDataUpdateToState(
      StreamHomeChartDataUpdate event) async* {
    await resetBloc();
    final currentState = state;
    if (currentState is HomeChartDataLoaded) {
      yield currentState.copyWith(dataState: DataState.loading);
      final List<ExpenseEntity> expenses = event.expenseList;
      _reportWeekMap = await reportUseCase.getTotalAmountOfDayMap(
        expenseList: expenses,
        totalAmountOfDayMap: _reportWeekMap,
        dateList: _dateOfWeekList,
      );
      final int totalAmount =
          reportUseCase.getTotalAmountOfWeek(_reportWeekMap!.values.toList());
      _reportDailyMap = await reportUseCase.getTotalAmountOfDayMap(
        expenseList: expenses,
        totalAmountOfDayMap: _reportDailyMap,
        dateList: _dateOfDailyList,
      );
      _reportMonthlyMap = await reportUseCase.getTotalAmountOfDayMap(
        expenseList: expenses,
        totalAmountOfDayMap: _reportMonthlyMap,
        dateList: _dateOfMonthlyList,
      );
      // _dataDaily = TotalExpenseDebtEntity(mapDaily);
      yield currentState.copyWith(
        dataState: DataState.success,
        reportDailyMap: _reportDailyMap,
        reportWeekMap: _reportWeekMap,
        reportMonthlyMap: _reportMonthlyMap,
        totalAmount: totalAmount,
      );
    }
  }

  Stream<HomeChartDataState> _mapPushErrorHomeChartDataToState(
      PushErrorHomeChartData event) async* {
    yield HomeChartDataFailure();
  }
}

Map<int, int> initialReportDataMap({DateTime? startDay, DateTime? endDate}) {
  final Map<int, int> reportDataMap = {};
  DateTime reportDay = startDay!;
  while (endDate!.compareTo(reportDay) == 0) {
    reportDataMap[reportDay.day] = 0;
    reportDay = reportDay.add(const Duration(days: 1));
    if (endDate.compareTo(reportDay) == 0) {
      reportDataMap[reportDay.day] = 0;
      break;
    }
  }
  return reportDataMap;
}

List<DateTime> initialDateList({DateTime? startDay, DateTime? endDate}) {
  final List<DateTime> dateList = [];
  DateTime reportDay = startDay!;
  while (endDate!.compareTo(reportDay) == 0) {
    dateList.add(reportDay);
    reportDay = reportDay.add(const Duration(days: 1));
    if (endDate.compareTo(reportDay) == 0) {
      dateList.add(reportDay);
      break;
    }
  }
  return dateList;
}
