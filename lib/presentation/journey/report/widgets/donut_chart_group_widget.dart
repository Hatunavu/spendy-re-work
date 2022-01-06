import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/utils/screen_utils.dart';
import 'package:spendy_re_work/domain/entities/report_total_category_spend_entity.dart';
import 'package:spendy_re_work/domain/usecases/report_usecase.dart';
import 'package:spendy_re_work/presentation/journey/report/report_page_constants.dart';
import 'package:spendy_re_work/presentation/journey/report/widgets/report_item_widget.dart';

import 'donut_chart_flutter/donut_chart.dart';
import 'donut_chart_flutter/total_container_widget.dart';

class DonutChartGroupWidget extends StatelessWidget {
  final int? totalMoneyOfMonth;
  final int? owedOfMonth;
  final Map<String, ReportTotalCateEntity>? mapWithCateKey;
  final String? currency;
  final ReportOfMonth? reportOfMonth;

  final listKey = const ObjectKey('donut-listview');

  DonutChartGroupWidget({
    this.mapWithCateKey,
    this.totalMoneyOfMonth,
    this.owedOfMonth,
    this.currency,
    this.reportOfMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: ReportPageConstants.paddingBody,
        right: ScreenUtil().setWidth(22),
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
                height: ReportPageConstants.sizePieChart,
                child: Stack(children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: TotalTextContainerWidget(
                          reportOfMonth!.totalAmount!, 0)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: DonutPieChart.withExpenseData(
                      mapWithCateKey: mapWithCateKey,
                      owedOfMonth: owedOfMonth,
                      reportOfCategoryList:
                          reportOfMonth!.reportByCategoryList!,
                      totalMoneyOfMonth: reportOfMonth?.totalAmount,
                    ),
                  )
                ])),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: ReportPageConstants.chartPiePaddingVertical,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ReportItemWidget(
                reportByCategory: reportOfMonth?.reportByCategoryList?[index],
                currency: currency,
              ),
              childCount: reportOfMonth?.reportByCategoryList?.length,
            ),
          )
        ],
      ),
    );
  }
}
