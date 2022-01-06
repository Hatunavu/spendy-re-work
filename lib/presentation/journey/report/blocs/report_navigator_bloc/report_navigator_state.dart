part of 'report_navigator_bloc.dart';

abstract class ReportNavigatorState extends Equatable {
  const ReportNavigatorState();
}

class ReportNavigatorChanged extends ReportNavigatorState {
  final DateTime dateTime;

  ReportNavigatorChanged(this.dateTime);

  @override
  List<Object> get props => [dateTime];
}
