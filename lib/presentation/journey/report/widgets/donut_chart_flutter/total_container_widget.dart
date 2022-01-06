import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/utils/screen_utils.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import '../../report_page_constants.dart';
import 'package:spendy_re_work/common/extensions/string_extensions.dart';

class TotalTextContainerWidget extends StatelessWidget {
  final int totalExpense;
  final int owed;

  TotalTextContainerWidget(
    this.totalExpense,
    this.owed,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: AppColor.bgGroupTotalPieChart,
          borderRadius: BorderRadius.all(Radius.circular(22.0))),
      height: ReportPageConstants.heightGroupTotalText,
      width: ReportPageConstants.widthGroupTotalText,
      child: Padding(
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(26)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _totalTitleText(
              ReportPageConstants.textTotalExpense,
            ),
            _totalMoneyText(totalExpense.toString()),
            SizedBox(
              height: ReportPageConstants.paddingBetweenTotalText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _totalTitleText(String text) {
    final totalChartStyle = ThemeText.getDefaultTextTheme()
        .textMenu
        .copyWith(fontSize: ReportPageConstants.fzTotalChart);

    return Text(
      text,
      style: totalChartStyle,
    );
  }

  Widget _totalMoneyText(String money) {
    final moneyChartStyle = ThemeText.getDefaultTextTheme()
        .textMoneyMenu
        .copyWith(fontSize: ReportPageConstants.fzMoneyChart);

    return Container(
        width: ReportPageConstants.widthMoneyText,
        alignment: Alignment.bottomLeft,
        child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('${money.formatStringToCurrency()}',
                style: moneyChartStyle)));
  }
}
