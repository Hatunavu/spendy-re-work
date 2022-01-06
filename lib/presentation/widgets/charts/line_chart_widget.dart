import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/date_time_format_constants.dart';
import 'package:spendy_re_work/common/extensions/num_extensions.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/common/utils/date_time_utils.dart';
import 'package:spendy_re_work/common/utils/device_dimension_utils.dart';
import 'package:spendy_re_work/common/utils/screen_utils.dart';
import 'package:spendy_re_work/presentation/journey/report/blocs/report_data_bloc/report_data_bloc.dart';
import 'package:spendy_re_work/presentation/journey/report/blocs/report_data_bloc/report_data_state.dart';
import 'package:spendy_re_work/presentation/journey/report/report_page_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_recent/transaction_recent_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/fl_chart_0_12_3/fl_chart.dart';

class LineChartWidget extends StatefulWidget {
  final LinkedHashMap<int, int>? barGroupDataMap;
  final double? heightChart;
  final int? countHorizontalLine;
  final DateTime? selectedTime;

  const LineChartWidget({
    Key? key,
    this.barGroupDataMap,
    this.heightChart,
    this.countHorizontalLine = 5,
    this.selectedTime,
  }) : super(key: key);

  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  List<FlSpot> rawLineData = [];

  late int? _maxElement; // max value in list
  late double _maxValueY; // max value after call ceilForInt()
  late double _intervalValue; // range of value . default this = _maxValueY / 5
  late bool _isEmpty;
  late List<int> _listValue;
  late double _maxX;
  final ScrollController _lineChartScrollController = ScrollController();
  late StreamSubscription<ReportDataState> _reportDataStateStreamSubscription;
  late DateTime _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = getEndDate(widget.selectedTime!);
    _reportDataStateStreamSubscription =
        BlocProvider.of<ReportDataBloc>(context).stream.listen((state) {
      if (state is ReportChartRefreshState) {
        _selectedTime = getEndDate(state.selectedTime);
        scrollChartToDate(_selectedTime);
      }
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      scrollChartToDate(_selectedTime);
    });
  }

  void _initData() {
    _maxX = DateTimeUtils.getMaxDateOfMonth(_selectedTime)!.toDouble();
    rawLineData = [];
    _listValue = [];
    _maxElement = 0;
    _maxValueY = 0;
    _intervalValue = 0;
    widget.barGroupDataMap!.forEach((k, v) => _listValue.add(v));

    _maxElement =
        _listValue.reduce((curr, element) => curr > element ? curr : element);

    _maxValueY = (_maxElement ?? 0).ceilForInt().toDouble();
    _intervalValue = _maxValueY / (widget.countHorizontalLine ?? 1);
    if (_intervalValue == 0) {
      _intervalValue = 1;
      _isEmpty = true;
    } else {
      _isEmpty = false;
    }

    widget.barGroupDataMap!.forEach((key, value) {
      rawLineData.add(convertMapToSpot(key - 1, value));
    });
  }

  @override
  void dispose() {
    _reportDataStateStreamSubscription.cancel();
    super.dispose();
  }

  void scrollChartToDate(DateTime dateTime) {
    final double percent =
        _lineChartScrollController.position.maxScrollExtent / _maxX;
    _lineChartScrollController.animateTo(_getValueToScroll(dateTime) * percent,
        curve: Curves.easeInOutCubic,
        duration: const Duration(milliseconds: 500));
  }

  double _getValueToScroll(DateTime date) {
    final int day = date.day;
    if (day < 10) {
      return 0;
    } else if (day >= 10 && day < 16) {
      return day - 16 * 0.5;
    } else if (day >= 16 && day <= 18) {
      return day * 1.0;
    } else if (day > 18) {
      if (day + (day - 18) * 0.5 > _maxX) {
        return _maxX;
      }
      return day + (day - 18) * 0.5;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    _initData();
    return Container(
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
                  LineChart(leftTitle()),
                  Container(
                    margin: EdgeInsets.only(left: 35.w),
                    padding: EdgeInsets.only(right: 10.w),
                    child: SingleChildScrollView(
                      controller: _lineChartScrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      child: Container(
                          width: DeviceDimension.getDeviceWidth(context) * 2,
                          margin: EdgeInsets.only(right: 15.w),
                          child: LineChart(chartData())),
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
          margin: 5.w,
          getTextStyles: (value) => TextStyle(
            color: const Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
          getTitles: (value) {
            return '';
          },
          reservedSize: 0,
        ),
        rightTitles: SideTitles(
          showTitles: false,
          margin: 50.w,
          reservedSize: 50.w,
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

  LineChartData leftTitle() {
    return LineChartData(
        gridData: FlGridData(
          show: false,
        ),
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 16.w,
            getTextStyles: (value) => TextStyle(
              color: const Color(0xff72719b),
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
            margin: 10.w,
            getTitles: (value) {
              return '';
            },
          ),
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) =>
                ThemeText.getDefaultTextTheme().titleStyle,
            margin: ScreenUtil().setWidth(5),
            reservedSize: 30.w,
            interval: _intervalValue,
            getTitles: (value) {
              for (int i = 0; i <= widget.countHorizontalLine!; i++) {
                if (value! / _intervalValue == i.toDouble()) {
                  return value.formatMoneyWithChar();
                }
              }
              return '';
            },
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        minX: 0,
        maxX: _maxX - 1,
        maxY: _maxValueY,
        minY: 0,
        lineBarsData: linesBarData(isVisible: false),
        lineTouchData: LineTouchData(enabled: false));
  }

  List<LineChartBarData> linesBarData({bool isVisible = true}) {
    final LineChartBarData lineChartBarData = LineChartBarData(
      spots: rawLineData,
      isCurved: true,
      preventCurveOverShooting: true,
      colors: [
        isVisible ? AppColor.green : AppColor.transparent,
      ],
      barWidth: 2,
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

  DateTime getEndDate(DateTime startDate) {
    final DateTime _now = DateTime.now();
    final DateTime firstDateOfCurrentMonth = DateTime(_now.year, _now.month, 1);
    if (startDate.isBefore(firstDateOfCurrentMonth)) {
      return DateTime(startDate.year, startDate.month + 1, 0);
    }
    return DateTime(_now.year, _now.month, _now.day + 1);
  }
}
