part of 'report_navigator_bloc.dart';

abstract class ReportNavigatorEvent extends Equatable {
  const ReportNavigatorEvent();
}

class IncrementMonth extends ReportNavigatorEvent {
  final DateTime dateTime;

  IncrementMonth(this.dateTime);

  @override
  List<Object> get props => [dateTime];
}

class DecrementMonth extends ReportNavigatorEvent {
  final DateTime dateTime;

  DecrementMonth(this.dateTime);

  @override
  List<Object> get props => [dateTime];
}

class SelectMonth extends ReportNavigatorEvent {
  final DateTime dateTime;

  SelectMonth(this.dateTime);

  @override
  List<Object> get props => [dateTime];
}
