import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';

abstract class ReportChartEvent extends Equatable {}

class ListenToReportEvent extends ReportChartEvent {
  final DateTime selectTime;

  ListenToReportEvent({required this.selectTime});

  @override
  List<Object> get props => [selectTime];
}

class RefreshReportDataEvent extends ReportChartEvent {
  final List<ExpenseEntity> expenseList;
  final DateTime? selectTime;

  RefreshReportDataEvent({
    required this.expenseList,
    this.selectTime,
  });

  @override
  List<Object> get props => [
        expenseList,
      ];
}

class LoadMoreReportDataEvent extends ReportChartEvent {
  final DateTime selectTime;

  LoadMoreReportDataEvent({required this.selectTime});

  @override
  List<Object> get props => [selectTime];
}
