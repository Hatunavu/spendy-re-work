import 'package:spendy_re_work/presentation/widgets/fl_chart_0_12_3/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:spendy_re_work/common/utils/screen_utils.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/state_widget/state_widget_constants.dart';

class EmptyHomeChartWidget extends StatefulWidget {
  final double heightChart;
  final List<int> listDay;
  final bool continuousInit; // call update in build method

  EmptyHomeChartWidget({
    required this.heightChart,
    required this.listDay,
    required this.continuousInit,
  });

  @override
  _EmptyHomeChartWidgetState createState() => _EmptyHomeChartWidgetState();
}

class _EmptyHomeChartWidgetState extends State<EmptyHomeChartWidget> {
  final double width = 8;

  List<BarChartGroupData> rawBarGroups = [];
  List<BarChartGroupData> showingBarGroups = [];
  late List<int> listValue;

  @override
  void initState() {
    super.initState();
    if (!widget.continuousInit) {
      _initData();
    }
  }

  void _initData() {
    rawBarGroups = [];
    listValue = [];
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
            maxY: 20,
            barTouchData: BarTouchData(
              enabled: false,
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) => titleStyle,
                margin: 8,
                reservedSize: 0,
                getTitles: (double? value) {
                  return (value!.toInt() + 1).toString();
                },
              ),
              leftTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) => titleStyle,
                margin: ScreenUtil().setWidth(5),
                reservedSize: ScreenUtil().setWidth(30),
                interval: 100,
                getTitles: (value) {
                  return '0';
                },
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                  top: BorderSide.none,
                  bottom: BorderSide.lerp(
                      const BorderSide(
                        color: AppColor.hindColor,
                      ),
                      const BorderSide(
                        color: AppColor.hindColor,
                      ),
                      1)),
            ),
            barGroups: [
              BarChartGroupData(x: widget.listDay[0] - 1, barRods: [
                BarChartRodData(
                  y: 8,
                  colors: [AppColor.hindColor],
                  width: width,
                ),
              ]),
              BarChartGroupData(x: widget.listDay[1] - 1, barRods: [
                BarChartRodData(
                  y: 13,
                  colors: [AppColor.hindColor],
                  width: width,
                ),
              ]),
              BarChartGroupData(x: widget.listDay[2] - 1, barRods: [
                BarChartRodData(
                  y: 18,
                  colors: [AppColor.hindColor],
                  width: width,
                ),
              ]),
              BarChartGroupData(x: widget.listDay[3] - 1, barRods: [
                BarChartRodData(
                  y: 15,
                  colors: [AppColor.hindColor],
                  width: width,
                ),
              ]),
              BarChartGroupData(x: widget.listDay[4] - 1, barRods: [
                BarChartRodData(
                  y: 10,
                  colors: [AppColor.hindColor],
                  width: width,
                ),
              ]),
              BarChartGroupData(x: widget.listDay[5] - 1, barRods: [
                BarChartRodData(
                  y: 5,
                  colors: [AppColor.hindColor],
                  width: width,
                ),
              ]),
              BarChartGroupData(x: widget.listDay[6] - 1, barRods: [
                BarChartRodData(
                  y: 12,
                  colors: [AppColor.hindColor],
                  width: width,
                ),
              ]),
            ],
          ),
        ));

    return Stack(
      alignment: Alignment.center,
      children: [
        barChart,
        Text(
          StateWidgetConstants.emptyDataContent,
          style: ThemeText.getDefaultTextTheme().textField,
        )
      ],
    );
  }

  // build bar item
  BarChartGroupData makeGroupData(int key, int money) {
    return BarChartGroupData(x: key, barRods: [
      BarChartRodData(
        y: money.toDouble(),
        colors: [AppColor.hindColor],
        width: width,
      ),
    ]);
  }
}
