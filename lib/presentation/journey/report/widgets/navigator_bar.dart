import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/date_time_format_constants.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/utils/date_time_utils.dart';
import 'package:spendy_re_work/presentation/journey/report/blocs/report_navigator_bloc/report_navigator_bloc.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/date_picker/spendy_date_picker.dart';
import 'package:spendy_re_work/common/extensions/string_extensions.dart';

class ReportNavigatorWidget extends StatelessWidget {
  final Function(DateTime)? reportChartCallBack;

  const ReportNavigatorWidget({Key? key, this.reportChartCallBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReportNavigatorBloc, ReportNavigatorState>(
        listener: (context, state) {
      if (state is ReportNavigatorChanged) {
        reportChartCallBack!(state.dateTime);
      }
    }, builder: (context, state) {
      if (state is ReportNavigatorChanged) {
        return GestureDetector(
          onTap: () => _showDateTimePicker(context, state.dateTime),
          child: _timeReportWidget(context, state.dateTime),
        );
      }
      return Container();
    });
  }

  void _showDateTimePicker(BuildContext context, DateTime dateTime) {
    final reportNavigatorBloc = BlocProvider.of<ReportNavigatorBloc>(context);
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LayoutConstants.roundedRadius),
        ),
        builder: (_) => DatePickerWidget(
              onDonePressed: (value) =>
                  _onDateTimeChanged(context, reportNavigatorBloc, value),
              initialDateTime: dateTime,
              minYear: 2010,
              maxYear: DateTime.now().year,
              maximumDate: DateTime.now(),
            ));
  }

  void _onDateTimeChanged(BuildContext context,
      ReportNavigatorBloc reportNavigatorBloc, DateTime dateTime) {
    reportNavigatorBloc.add(SelectMonth(dateTime));
  }

  Widget _timeReportWidget(BuildContext context, DateTime dateTime) {
    return Container(
      padding: const EdgeInsets.only(
        left: LayoutConstants.dimen_18,
        top: LayoutConstants.dimen_8,
        right: LayoutConstants.dimen_8,
        bottom: LayoutConstants.dimen_8,
      ),
      decoration: BoxDecoration(
        color: AppColor.bgGroupTotalPieChart,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              DateTimeUtils.getStringDate(
                      context, dateTime, DateTimeFormatConstants.timeMMMyyyy)
                  .capitalize,
              style: ThemeText.getDefaultTextTheme().textDateRange.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
          const SizedBox(
            width: 9,
          ),
          Image.asset(IconConstants.calendarIcon),
        ],
      ),
    );
  }
}
