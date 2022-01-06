import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/firebase_storage_constants.dart';
import 'package:spendy_re_work/common/enums/data_state.dart';
import 'package:spendy_re_work/domain/entities/category_entity.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/usecases/categories_usecase.dart';
import 'package:spendy_re_work/domain/usecases/report_usecase.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/journey/report/blocs/report_data_bloc/report_data_event.dart';
import 'package:spendy_re_work/presentation/journey/report/blocs/report_data_bloc/report_data_state.dart';

class ReportDataBloc extends Bloc<ReportChartEvent, ReportDataState> {
  final ReportUseCase reportUseCase;
  final AuthenticationBloc authBloc;
  final CategoriesUseCase categoriesUseCase;

  final _now = DateTime.now();
  int _selectYear = DateTime.now().year;
  int _selectMonth = DateTime.now().month;
  List<ExpenseEntity> _expenseList = [];
  List<CategoryEntity> _categoryList = [];
  final Map<int, dynamic> _totalAmountOfYearMap = Map<int, dynamic>();
  Map<int, int>? _reportMonthlyMap;
  List<DateTime>? _dateOfMonthlyList;

  ReportDataBloc({
    required this.reportUseCase,
    required this.authBloc,
    required this.categoriesUseCase,
  }) : super(ReportChartInitialState.init()) {
    _reportMonthlyMap = initialReportDataMap(
        startDay: DateTime(_now.year, _now.month, 1),
        endDate: DateTime(_now.year, _now.month, _now.day));
    _dateOfMonthlyList = initialDateList(
        startDay: DateTime(_now.year, _now.month, 1),
        endDate: DateTime(_now.year, _now.month, _now.day));
  }

  @override
  Stream<ReportDataState> mapEventToState(ReportChartEvent event) async* {
    switch (event.runtimeType) {
      case ListenToReportEvent:
        await _listenExpenseReport(event as ListenToReportEvent);
        break;
      case RefreshReportDataEvent:
        yield* _mapRefreshReportDataEventToState(event as RefreshReportDataEvent);
        break;
      case LoadMoreReportDataEvent:
        yield* _loadMoreReportDataByYear(event as LoadMoreReportDataEvent);
        break;
    }
  }

  Stream<ReportDataState> _loadMoreReportDataByYear(LoadMoreReportDataEvent event) async* {
    final user = authBloc.userEntity;

    _selectYear = event.selectTime.year;
    _selectMonth = event.selectTime.month;
    if (_totalAmountOfYearMap[_selectYear] == null) {
      reportUseCase.requestMoreReportDataByYear(
        uid: user.uid,
        startDay: DateTime(_selectYear, _selectMonth, 1).millisecondsSinceEpoch,
        endDate: DateTime(_selectYear, _selectMonth + 1, 1).millisecondsSinceEpoch,
      );
    } else {
      final Map<int, int> totalAmountOfMonthMap =
          Map<int, int>.from(_totalAmountOfYearMap[_selectYear]);
      if (totalAmountOfMonthMap[_selectMonth] == 0) {
        reportUseCase.requestMoreReportDataByYear(
          uid: user.uid,
          startDay: DateTime(_selectYear, _selectMonth, 1).millisecondsSinceEpoch,
          endDate: DateTime(_selectYear, _selectMonth + 1, 1).millisecondsSinceEpoch,
        );
      } else {
        final currentState = state;
        if (currentState is ReportChartInitialState) {
          yield currentState.copyWith(
            dataState: DataState.loading,
          );

          final ReportOfMonth reportOfMonth = await reportUseCase.getReportOfMonth(
            expenseList: _expenseList,
            selectMonth: _selectMonth,
            selectYear: _selectYear,
            categoryList: _categoryList,
          );

          final bool reportOfYearEmptyData = _checkReportOfYearEmptyData(Map<int, int>.from(
            _totalAmountOfYearMap[_selectYear],
          ));

          final DateTime startDate = DateTime(_selectYear, _selectMonth, 1);
          final DateTime endDate = getEndDate(startDate);
          _reportMonthlyMap?.clear();
          _reportMonthlyMap = initialReportDataMap(startDay: startDate, endDate: endDate);
          _dateOfMonthlyList = initialDateList(startDay: startDate, endDate: endDate);
          _reportMonthlyMap = await reportUseCase.getTotalAmountOfDayMap(
            expenseList: _expenseList,
            totalAmountOfDayMap: _reportMonthlyMap,
            dateList: _dateOfMonthlyList,
          );
          yield ReportChartRefreshState(event.selectTime);
          yield currentState.copyWith(
              dataState: DataState.success,
              totalAmountOfMonthMap: Map<int, int>.from(
                _totalAmountOfYearMap[_selectYear],
              ),
              totalAmountOfDayMap: Map<int, int>.from(_reportMonthlyMap!),
              reportOfMonth: reportOfMonth,
              emptyDataChart: reportOfYearEmptyData,
              selectedTime: event.selectTime);
        }
      }
    }
  }

  Future<void> _listenExpenseReport(ListenToReportEvent event) async {
    final user = authBloc.userEntity;
    _selectYear = event.selectTime.year;
    _selectMonth = event.selectTime.month;

    reportUseCase
        .listenToExpensesHomeReport(
            uid: user.uid,
            startDay: DateTime(_selectYear, _selectMonth, 1),
            endDate: DateTime(_selectYear, _selectMonth + 1, 1))
        .listen((expenseData) async {
      await refreshData();
      add(RefreshReportDataEvent(expenseList: expenseData));
    });
  }

  Stream<ReportDataState> _mapRefreshReportDataEventToState(RefreshReportDataEvent event) async* {
    final currentState = state;
    _expenseList = event.expenseList;

    if (currentState is ReportChartInitialState) {
      try {
        yield currentState.copyWith(dataState: DataState.loading);
        if (authBloc.categoryList.isEmpty) {
          authBloc.categoryList = await categoriesUseCase.getCategoryListCate(
              authBloc.userEntity.uid!, FirebaseStorageConstants.transactionType);
        }
        _categoryList = authBloc.categoryList;
        // initialReportDataMap(startDay: event.firstDayOfYear, endDate: event.lastDayOfYear);
        // #1 Get Total amount of Month for select month
        _reportMonthlyMap = await reportUseCase.getTotalAmountOfDayMap(
          expenseList: _expenseList,
          totalAmountOfDayMap: _reportMonthlyMap,
          dateList: _dateOfMonthlyList,
        );

        final Map<int, int> totalAmountOfMonthMap = await reportUseCase.getTotalAmountOfMonthMap(
            expenseList: _expenseList,
            totalAmountOfDayMap: {
              1: 0,
              2: 0,
              3: 0,
              4: 0,
              5: 0,
              6: 0,
              7: 0,
              8: 0,
              9: 0,
              10: 0,
              11: 0,
              12: 0,
            },
            selectYear: _selectYear);
        final bool reportOfYearEmptyData = _checkReportOfYearEmptyData(totalAmountOfMonthMap);
        // #2 Add this Total amount of Month to Map
        _totalAmountOfYearMap[_selectYear] = totalAmountOfMonthMap;
        final ReportOfMonth reportOfMonth = await reportUseCase.getReportOfMonth(
          expenseList: _expenseList,
          selectMonth: _selectMonth,
          selectYear: _selectYear,
          categoryList: _categoryList,
        );
        yield currentState.copyWith(
            dataState: DataState.success,
            totalAmountOfMonthMap: Map<int, int>.from(
              _totalAmountOfYearMap[_selectYear],
            ),
            reportOfMonth: reportOfMonth,
            totalAmountOfDayMap: _reportMonthlyMap,
            emptyDataChart: reportOfYearEmptyData,
            selectedTime: DateTime(_selectYear, _selectMonth));
      } catch (e) {
        yield currentState.copyWith(
          dataState: DataState.success,
          totalAmountOfMonthMap: Map<int, int>.from(
            _totalAmountOfYearMap[_selectYear],
          ),
          reportOfMonth: ReportOfMonth.normal(),
        );
      }
    }
  }

  bool _checkReportOfYearEmptyData(Map<int, int> reportOfYearMap) {
    for (int index = 1; index <= 12; index++) {
      if (reportOfYearMap[index] != 0) {
        return false;
      }
    }
    return true;
  }

  Map<int, int> initialReportDataMap({DateTime? startDay, DateTime? endDate}) {
    final Map<int, int> reportDataMap = {};
    DateTime reportDay = startDay!;
    do {
      reportDataMap[reportDay.day] = 0;
      reportDay = reportDay.add(const Duration(days: 1));
    } while (endDate!.compareTo(reportDay) >= 0);
    return reportDataMap;
  }

  List<DateTime> initialDateList({DateTime? startDay, DateTime? endDate}) {
    final List<DateTime> dateList = [];
    DateTime reportDay = startDay!;
    do {
      dateList.add(reportDay);
      reportDay = reportDay.add(const Duration(days: 1));
    } while (endDate!.compareTo(reportDay) >= 0);
    return dateList;
  }

  Future refreshData() async {
    final DateTime startDate = DateTime(_selectYear, _selectMonth, 1);
    final DateTime endDate = getEndDate(startDate);
    _expenseList.clear();
    _categoryList.clear();
    _reportMonthlyMap?.clear();

    _reportMonthlyMap = initialReportDataMap(startDay: startDate, endDate: endDate);
    _dateOfMonthlyList = initialDateList(startDay: startDate, endDate: endDate);
  }

  DateTime getEndDate(DateTime startDate) {
    final DateTime firstDateOfCurrentMonth = DateTime(_now.year, _now.month, 1);
    if (startDate.isBefore(firstDateOfCurrentMonth)) {
      return DateTime(startDate.year, startDate.month + 1, 0);
    }
    return DateTime(_now.year, _now.month, _now.day + 1);
  }
}
