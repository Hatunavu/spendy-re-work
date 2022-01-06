import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:spendy_re_work/common/extensions/date_time_extensions.dart';

part 'report_navigator_event.dart';

part 'report_navigator_state.dart';

class ReportNavigatorBloc
    extends Bloc<ReportNavigatorEvent, ReportNavigatorState> {
  ReportNavigatorBloc() : super(ReportNavigatorChanged(DateTime.now()));

  DateTime? _dateTimeSelected = DateTime.now();

  final _maximumTime = DateTime.now();

  @override
  Stream<ReportNavigatorState> mapEventToState(
    ReportNavigatorEvent event,
  ) async* {
    if (event is IncrementMonth) {
      yield* _mapIncrementMonthToState(event);
    } else if (event is DecrementMonth) {
      yield* _mapDecrementMonthToState(event);
    } else if (event is SelectMonth) {
      yield* _mapSelectMonthToState(event);
    }
  }

  ReportNavigatorChanged getInit() {
    _dateTimeSelected = DateTime.now();
    _onDateTimeSelected(_dateTimeSelected!);
    return ReportNavigatorChanged(_dateTimeSelected!);
  }

  Stream<ReportNavigatorState> _mapIncrementMonthToState(
      IncrementMonth event) async* {
    if (_dateTimeSelected!.year < _maximumTime.year ||
        (_dateTimeSelected!.year == _maximumTime.year &&
            _dateTimeSelected!.month < _maximumTime.month)) {
      _dateTimeSelected = event.dateTime.addMonth(value: 1);
      _onDateTimeSelected(_dateTimeSelected!);

      yield ReportNavigatorChanged(_dateTimeSelected!);
    }
  }

  Stream<ReportNavigatorState> _mapDecrementMonthToState(
      DecrementMonth event) async* {
    _dateTimeSelected = event.dateTime.subMonth(value: 1);
    _onDateTimeSelected(_dateTimeSelected!);

    yield ReportNavigatorChanged(_dateTimeSelected!);
  }

  Stream<ReportNavigatorState> _mapSelectMonthToState(
      SelectMonth event) async* {
    if (_dateTimeSelected != event.dateTime) {
      _dateTimeSelected = event.dateTime;
      _onDateTimeSelected(event.dateTime);
    }

    yield ReportNavigatorChanged(_dateTimeSelected!);
  }

  void _onDateTimeSelected(DateTime dateTime) {
    // reportBloc.add(FetchReportData(dateTime));
  }
}
