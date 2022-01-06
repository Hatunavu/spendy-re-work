import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/image_constants.dart';
import 'package:spendy_re_work/common/utils/screen_utils.dart';
import 'package:spendy_re_work/domain/entities/report_total_category_spend_entity.dart';
import 'package:spendy_re_work/domain/usecases/report_usecase.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../report_page_constants.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class DonutPieChart extends StatelessWidget {
  // final List<charts.Series> seriesList;
  final bool? animate;
  final Map<String, double> reportMap;
  final List<Color>? colorList;
  final int? totalMoneyOfMonth;
  final int? owedOfMonth;

  DonutPieChart(
      {this.totalMoneyOfMonth,
      this.owedOfMonth,
      this.colorList,
      this.animate = false,
      required this.reportMap});

  factory DonutPieChart.withExpenseData({
    Map<String, ReportTotalCateEntity>? mapWithCateKey,
    required totalMoneyOfMonth,
    int? owedOfMonth,
    required List<ReportByCategory> reportOfCategoryList,
  }) {
    final _reportMap = <String, double>{};
    final _colorList = <Color>[];
    for (final category in reportOfCategoryList) {
      _reportMap[category.category!.name!] = category.percent!;
      _colorList.add(category.category!.color!);
    }
    return DonutPieChart(
      reportMap: _reportMap,
      animate: false,
      colorList: _colorList,
      owedOfMonth: owedOfMonth,
      totalMoneyOfMonth: totalMoneyOfMonth,
    );
  }

  @override
  Widget build(BuildContext context) {
    final centerPieChart = Container(
      alignment: Alignment.center,
      color: Colors.white,
      height: ScreenUtil().setHeight(100),
      width: ScreenUtil().setHeight(100),
      child: Image.asset(
        ImageConstants.imgCenterPieChart,
      ),
    );

    return SizedBox(
      height: ReportPageConstants.sizePieChart,
      child: Stack(
        alignment: Alignment.center,
        children: [
          centerPieChart,
          SizedBox(
            width: ReportPageConstants.sizePieChart,
            height: ReportPageConstants.sizePieChart,
            // child: charts.PieChart(seriesList,
            //     animate: animate,
            //     layoutConfig: LayoutConfig(
            //       rightMarginSpec: MarginSpec.fixedPixel(0),
            //       leftMarginSpec: MarginSpec.fixedPixel(0),
            //       bottomMarginSpec: MarginSpec.fixedPixel(0),
            //       topMarginSpec: MarginSpec.fixedPixel(0),
            //     ),
            //     defaultRenderer: charts.ArcRendererConfig(
            //       arcWidth: ScreenUtil().setWidth(30).toInt(),
            //       strokeWidthPx: 0.0,
            //     )),
            child: PieChart(
              dataMap: reportMap,
              chartType: ChartType.ring,
              colorList: colorList ?? [],
              ringStrokeWidth: 31.w,
              chartRadius: 130.w,
              legendOptions: const LegendOptions(
                  showLegendsInRow: false, showLegends: false),
              chartValuesOptions: const ChartValuesOptions(
                  showChartValueBackground: false, showChartValues: false),
            ),
          ),
        ],
      ),
    );
  }
}
