import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/date_time_format_constants.dart';
import 'package:spendy_re_work/common/extensions/num_extensions.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/common/utils/date_time_utils.dart';
import 'package:spendy_re_work/common/utils/device_dimension_utils.dart';
import 'package:spendy_re_work/common/utils/screen_utils.dart';
import 'package:spendy_re_work/presentation/journey/report/report_page_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_recent/transaction_recent_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/fl_chart_0_12_3/fl_chart.dart';
import 'package:spendy_re_work/presentation/widgets/state_widget/state_widget_constants.dart';

class EmptyReportChartWidget extends StatefulWidget {
  final double? heightChart;
  final int? countHorizontalLine;
  final DateTime? selectedTime;

  EmptyReportChartWidget({
    Key? key,
    this.heightChart,
    this.countHorizontalLine = 5,
    this.selectedTime,
  }) : super(key: key);

  @override
  _EmptyReportChartWidgetState createState() => _EmptyReportChartWidgetState();
}

class _EmptyReportChartWidgetState extends State<EmptyReportChartWidget> {
  List<FlSpot> rawLineData = [];
  Map<int, int> barGroupDataMap = {
    1: 2,
    3: 10,
    6: 0,
    9: 8,
    11: 2,
    14: 8,
  };

  late int _maxElement; // max value in list
  late double _maxValueY; // max value after call ceilForInt()
  late double _intervalValue; // range of value . default this = _maxValueY / 5
  late bool _isEmpty;
  late List<int> _listValue;
  late double _maxX;

  @override
  void initState() {
    super.initState();
    _initData();
    // convert map to list
  }

  void _initData() {
    _maxX = DateTimeUtils.getMaxDateOfMonth(widget.selectedTime!)!.toDouble();
    rawLineData = [];
    _listValue = [];
    _maxElement = 0;
    _maxValueY = 0;
    _intervalValue = 0;
    barGroupDataMap.forEach((k, v) => _listValue.add(v));

    _maxElement =
        _listValue.reduce((curr, element) => curr > element ? curr : element);

    _maxValueY = _maxElement.ceilForInt().toDouble();
    _intervalValue = _maxValueY / (widget.countHorizontalLine ?? 1);

    if (_intervalValue == 0) {
      _intervalValue = 1;
      _isEmpty = true;
    } else {
      _isEmpty = false;
    }

    barGroupDataMap.forEach((key, value) {
      rawLineData.add(convertMapToSpot(key - 1, value));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          height: widget.heightChart ?? 500,
          padding: TransactionRecentConstants.paddingChartContainer,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(18)),
            color: AppColor.bgGroupTotalPieChart,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${ReportPageConstants.titleLineChart} ${DateTimeUtils.getStringDate(context, widget.selectedTime!, DateTimeFormatConstants.fullMonth).toLowerCase()}',
                style: ThemeText.getDefaultTextTheme().textLabelChart,
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 6.w, top: 5.w),
                  child: Stack(
                    children: [
                      //LineChart(leftTitle()),
                      Container(
                        padding: EdgeInsets.only(right: 10.w),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          child: Container(
                              width:
                                  DeviceDimension.getDeviceWidth(context) * 2,
                              child: Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child: LineChart(chartData()),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        Text(
          StateWidgetConstants.emptyDataContent,
          style: ThemeText.getDefaultTextTheme().textField,
        )
      ],
    );
  }

  LineChartData chartData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: false,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: true,
        horizontalInterval: _intervalValue,
        checkToShowHorizontalLine: (value) {
          // draw horizontal line with value
          for (int i = 0; i <= widget.countHorizontalLine!; i++) {
            if (value / _intervalValue == i.toDouble()) {
              return true;
            }
          }

          return false;
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColor.hindColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        leftTitles: SideTitles(
          showTitles: true,
          margin: ScreenUtil().setWidth(5),
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            return '';
          },
          reservedSize: 0,
        ),
        rightTitles: SideTitles(
          showTitles: false,
          margin: ScreenUtil().setWidth(50),
          reservedSize: 50,
        ),
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => ThemeText.getDefaultTextTheme().titleStyle,
          margin: 8.h,
          reservedSize: 15.h,
          getTitles: (double? value) {
            return (value!.toInt() + 1).toString();
          },
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
            top: _isEmpty
                ? BorderSide.none
                : BorderSide.lerp(
                    const BorderSide(
                      color: AppColor.hindColor,
                    ),
                    const BorderSide(
                      color: AppColor.hindColor,
                    ),
                    1),
            bottom: BorderSide.lerp(
                const BorderSide(
                  color: AppColor.hindColor,
                ),
                const BorderSide(
                  color: AppColor.hindColor,
                ),
                1)),
      ),
      minX: 0,
      maxX: _maxX - 1,
      maxY: _maxValueY,
      minY: 0,
      lineBarsData: linesBarData(isVisible: true),
    );
  }

  List<LineChartBarData> linesBarData({bool isVisible = true}) {
    final LineChartBarData lineChartBarData = LineChartBarData(
      spots: rawLineData,
      isCurved: true,
      colors: [
        isVisible ? AppColor.hindColor : AppColor.transparent,
      ],
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
    );
    return [
      lineChartBarData,
    ];
  }

  FlSpot convertMapToSpot(int key, int money) {
    return FlSpot(key.toDouble(), money.toDouble());
  }
}
