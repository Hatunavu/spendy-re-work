import 'dart:collection';
import 'package:spendy_re_work/common/extensions/num_extensions.dart';
import 'package:spendy_re_work/presentation/widgets/fl_chart_0_12_3/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/utils/screen_utils.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class ColumnChartWidget extends StatefulWidget {
  final LinkedHashMap<int, int> barGroupDataMap;
  final double heightChart;
  final int countHorizontalLine;
  final bool continuousInit; // call update in build method
  final int? keyHighlight;

  ColumnChartWidget(this.heightChart,
      {required this.barGroupDataMap,
      this.countHorizontalLine = 5,
      this.continuousInit = false,
      this.keyHighlight});

  @override
  State<StatefulWidget> createState() => ColumnChartWidgetState();
}

class ColumnChartWidgetState extends State<ColumnChartWidget> {
  final Color color1 = AppColor.chartBlueLight;
  final Color color2 = AppColor.chartYellow;
  final Color color3 = AppColor.chartRed;
  final Color color4 = AppColor.chartBlue;

  final double width = 8;

  List<BarChartGroupData> rawBarGroups = [];
  late List<BarChartGroupData> showingBarGroups;

  late int _maxElement; // max value in list

  late double _maxValueY; // max value after call ceilForInt()
  late double _intervalValue; // range of value . default this = _maxValueY / 5
  late bool _isEmpty;

  late List<int> _listValue;

  @override
  void initState() {
    super.initState();
    // convert map to list
    if (!widget.continuousInit) {
      _initData();
    }
  }

  void _initData() {
    rawBarGroups = [];
    _listValue = [];
    _maxElement = 0;
    _maxValueY = 0;
    _intervalValue = 0;
    widget.barGroupDataMap.forEach((k, v) => _listValue.add(v));

    _maxElement =
        _listValue.reduce((curr, element) => curr > element ? curr : element);

    _maxValueY = _maxElement.ceilForInt().toDouble();

    _intervalValue = _maxValueY / widget.countHorizontalLine;
    if (_intervalValue == 0) {
      // when empty data
      _intervalValue = 1;
      _isEmpty = true;
    } else {
      _isEmpty = false;
    }

    // map data to bar
    widget.barGroupDataMap.forEach((key, value) {
      rawBarGroups.add(makeGroupData(key - 1, value));
    });

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.continuousInit) {
      _initData();
    }
    final titleStyle = ThemeText.getDefaultTextTheme()
        .textMoneyMenu
        .copyWith(fontSize: ScreenUtil().setSp(10), color: AppColor.textColor);

    final barChart = SizedBox(
        width: double.infinity,
        height: widget.heightChart,
        child: BarChart(
          BarChartData(
            maxY: _maxValueY,
            barTouchData: BarTouchData(
              enabled: false,
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) => titleStyle,
                margin: 10.h,
                reservedSize: 13.h,
                getTitles: (double? value) {
                  return (value!.toInt() + 1).toString();
                },
              ),
              leftTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) => titleStyle,
                margin: ScreenUtil().setWidth(5),
                reservedSize: ScreenUtil().setWidth(30),
                interval: _intervalValue,
                getTitles: (value) {
                  for (int i = 0; i <= widget.countHorizontalLine; i++) {
                    if (value! / _intervalValue == i.toDouble()) {
                      return value.formatMoneyWithChar();
                    }
                  }
                  return '';
                },
              ),
            ),
            gridData: FlGridData(
              show: true,
              horizontalInterval: _intervalValue,
              checkToShowHorizontalLine: (value) {
                // draw horizontal line with value
                for (int i = 0; i <= widget.countHorizontalLine; i++) {
                  if (value / _intervalValue == i.toDouble()) {
                    return true;
                  }
                }

                return false;
              },
              getDrawingHorizontalLine: (value) {
//              print('getDrawingHorizontalLine: $value');
                return FlLine(
                  color: AppColor.hindColor,
                  strokeWidth: 1,
                );
              },
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
            barGroups: showingBarGroups,
          ),
        ));

    return barChart;
  }

  // build bar item
  BarChartGroupData makeGroupData(int key, int money) {
    return BarChartGroupData(x: key, barRods: [
      BarChartRodData(
        y: money.toDouble(),
        colors: _setColor(key + 1),
        width: width,
      ),
    ]);
  }

  List<Color> _setColor(int key) {
    if (widget.keyHighlight == null) {
      return key % 4 == 0
          ? [color4]
          : key % 3 == 0
              ? [color3]
              : key % 2 == 0
                  ? [color2]
                  : [color1];
    } else {
      if (key == widget.keyHighlight) {
        return [AppColor.chartRed];
      } else {
        return [AppColor.textHideColor.withOpacity(0.4)];
      }
    }
  }
}
