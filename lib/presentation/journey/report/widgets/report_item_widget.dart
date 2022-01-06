import 'package:flutter/material.dart';

import 'package:spendy_re_work/common/extensions/string_extensions.dart';
import 'package:spendy_re_work/common/constants/category_name_map.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/domain/usecases/report_usecase.dart';
import 'package:spendy_re_work/presentation/journey/report/report_page_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

class ReportItemWidget extends StatelessWidget {
  final ReportByCategory? reportByCategory;
  final String? currency;

  const ReportItemWidget({Key? key, this.reportByCategory, this.currency})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 26),
      child: Row(
        children: [
          Expanded(
            flex: 40,
            child: Row(
              children: [
                Container(
                  height: LayoutConstants.dimen_7,
                  width: LayoutConstants.dimen_7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: reportByCategory?.category?.color,
                    border: Border.all(
                        width: 5.0, color: reportByCategory!.category!.color!),
                  ),
                ),
                const SizedBox(
                  width: LayoutConstants.dimen_6,
                ),
                Expanded(
                  child: Text(
                    CategoryCommon
                        .categoryNameMap[reportByCategory!.category!.name]!,
                    style: ThemeText.getDefaultTextTheme().textMenu.copyWith(
                        color: AppColor.textChartGrey,
                        fontSize: ReportPageConstants.fzTotalChart),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              flex: 19,
              child: Text(
                '${reportByCategory!.percent} %',
                textAlign: TextAlign.end,
                style: ThemeText.getDefaultTextTheme()
                    .textMoneyMenu
                    .copyWith(fontSize: ReportPageConstants.fzTotalChart),
              )),
          Expanded(
            flex: 41,
            child: Container(
              width: ReportPageConstants.widthMoneyTextItem,
              alignment: Alignment.centerRight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${reportByCategory?.amount?.toInt().toString().formatStringToCurrency()}',
                  style: ThemeText.getDefaultTextTheme().textMoneyMenu.copyWith(
                      color: AppColor.chartRed,
                      fontSize: ReportPageConstants.fzTotalChart),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
