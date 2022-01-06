import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/key_constants.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/common/enums/data_state.dart';
import 'package:spendy_re_work/common/utils/screen_utils.dart';
import 'package:spendy_re_work/domain/usecases/report_usecase.dart';
import 'package:spendy_re_work/presentation/journey/report/blocs/report_data_bloc/report_data_bloc.dart';
import 'package:spendy_re_work/presentation/journey/report/blocs/report_data_bloc/report_data_event.dart';
import 'package:spendy_re_work/presentation/journey/report/blocs/report_data_bloc/report_data_state.dart';
import 'package:spendy_re_work/presentation/journey/report/report_page_constants.dart';
import 'package:spendy_re_work/presentation/journey/report/widgets/appbar_report_widget.dart';
import 'package:spendy_re_work/presentation/journey/report/widgets/donut_chart_group_widget.dart';
import 'package:spendy_re_work/presentation/widgets/charts/line_chart_widget.dart';
import 'package:spendy_re_work/presentation/widgets/skeleton_widget/chart_skeleton_widget.dart';
import 'package:spendy_re_work/presentation/widgets/state_widget/empty_chart/empty_report_chart_widget.dart';
import 'package:spendy_re_work/presentation/widgets/state_widget/empty_data_widget.dart';

class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarReportWidget(
        reportChartCallback: (dateTime) =>
            _reportChartCallback(context, dateTime),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<ReportDataBloc, ReportDataState>(
        builder: (context, state) {
      if (state is ReportChartInitialState) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: ReportPageConstants.paddingBody,
                top: ReportPageConstants.paddingTop,
                right: ReportPageConstants.paddingBody,
              ),
              child: _reportOfYearWidget(state),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(40),
            ),
            Expanded(child: _reportMonthWidget(state, context)),
          ],
        );
      } else {
        return ChartSkeletonWidget(
          ReportPageConstants.heightBarChart,
        );
      }
    });
  }

  Widget _reportOfYearWidget(ReportChartInitialState state) {
    if (state.dataState == DataState.success) {
      return _isDataEmpty(state.totalAmountOfDayMap!)
          ? EmptyReportChartWidget(
              heightChart: ReportPageConstants.heightBarChart,
              selectedTime: state.selectedTime)
          : LineChartWidget(
              heightChart: ReportPageConstants.heightBarChart,
              barGroupDataMap: LinkedHashMap.from(state.totalAmountOfDayMap!),
              selectedTime: state.selectedTime,
            );
    } else if (state.dataState == DataState.loading) {
      return ChartSkeletonWidget(
        ReportPageConstants.heightBarChart,
      );
    } else {
      return EmptyReportChartWidget(
          heightChart: ReportPageConstants.heightBarChart,
          selectedTime: state.selectedTime);
    }
  }

  Widget _reportMonthWidget(
      ReportChartInitialState state, BuildContext context) {
    if (state.dataState == DataState.success) {
      if (state.reportOfMonth!.reportByCategoryList != null &&
          state.reportOfMonth!.reportByCategoryList!.isNotEmpty) {
        return _existReportMonthDataWidget(reportOfMonth: state.reportOfMonth);
      }
    } else if (state.dataState == DataState.loading) {
      return ChartSkeletonWidget(
        ReportPageConstants.heightBarChart,
      );
    }
    return EmptyDataWidget(
      titleButton: ReportPageConstants.createFirstExpense,
      onPressButton: () => _createFirstExpense(context),
    );
  }

  Widget _existReportMonthDataWidget({ReportOfMonth? reportOfMonth}) {
    return DonutChartGroupWidget(
      reportOfMonth: reportOfMonth!,
    );
  }

  void _reportChartCallback(BuildContext context, DateTime dateTime) {
    BlocProvider.of<ReportDataBloc>(context).add(LoadMoreReportDataEvent(
      selectTime: dateTime,
    ));
  }

  // Check Chart is empty
  bool _isDataEmpty(Map<int, int> reportMap) {
    for (final int amount in reportMap.values.toList()) {
      if (amount > 0) {
        return false;
      }
    }
    return true;
  }

  void _createFirstExpense(BuildContext context) {
    Navigator.pushNamed(context, RouteList.personalExpense, arguments: {
      KeyConstants.routeKey: RouteList.home,
      KeyConstants.editExpenseKey: false,
      KeyConstants.expenseDetailKey: null,
    });
  }
}
