import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/column_chart_value_type_constants.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/extensions/string_extensions.dart';
import 'package:spendy_re_work/domain/entities/total_expense_debt_entity.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_recent/transaction_recent_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/charts/column_chart_widget.dart';
import 'package:spendy_re_work/presentation/widgets/state_widget/empty_chart/empty_home_chart_widget.dart';

import 'bloc/home_chart_bloc.dart';

// ignore: must_be_immutable
class HomeChartPageViewWidget extends StatelessWidget {
  final String? title;
  final Map<int, int>? reportDailyMap;
  final Map<int, int>? reportWeekMap;
  final ColumnChartValueTypeEnum? typeEnum;
  final int? index;
  int totalAmount;

  int _total = 0;
  Map<int, int>? _dataSettleDebtSelected;

  final _popupItems = <ColumnChartValueTypeEnum>[
    ColumnChartValueTypeEnum.daily,
    ColumnChartValueTypeEnum.week
  ].map<PopupMenuItem<ColumnChartValueTypeEnum>>(
      (ColumnChartValueTypeEnum value) {
    return PopupMenuItem<ColumnChartValueTypeEnum>(
      height: TransactionRecentConstants.popupMenuItemHeight,
      value: value,
      child: Text(
        mapChartTypeToString(value)!,
        style: ThemeText.getDefaultTextTheme()
            .caption
            ?.copyWith(color: AppColor.iconColorPrimary),
      ),
    );
  }).toList();

  HomeChartPageViewWidget(
      {required this.title,
      this.index,
      this.typeEnum = ColumnChartValueTypeEnum.daily,
      required this.reportWeekMap,
      this.totalAmount = 0,
      this.reportDailyMap}) {
    switch (typeEnum) {
      case ColumnChartValueTypeEnum.daily:
        // #1: Check Daily chart data is exist
        if (!_isDataEmpty(reportDailyMap!)) {
          // #2: If exist, get total amount today and get report daily map
          // _selectedData = reportDailyMap;
          _total = reportDailyMap![DateTime.now().day]!;
          _dataSettleDebtSelected = reportDailyMap;
        } else {
          // #3: If not exist, show empty chart data
          _total = 0;
          _dataSettleDebtSelected = TotalExpenseDebtEntity.initDailyMapEmpty();
        }
        // _total = reportDailyMap[DateTime.now().day];
        // _dataSettleDebtSelected = reportDailyMap;
        break;
      case ColumnChartValueTypeEnum.week:
        if (!_isDataEmpty(reportWeekMap!)) {
          // _selectedData = dataWeek;
          _total = totalAmount;
          _dataSettleDebtSelected = reportWeekMap;
          // _assignTotal(reportWeekMap);
        } else {
          _total = 0;
          _dataSettleDebtSelected = TotalExpenseDebtEntity.initWeekMapEmpty();
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: TransactionRecentConstants.paddingChartPage,
      child: Container(
        padding: TransactionRecentConstants.paddingChartContainer,
        alignment: Alignment.center,
        // height: TransactionRecentConstants.heightContainerChart,
        decoration: const BoxDecoration(
            color: AppColor.bgGroupTotalPieChart,
            borderRadius: BorderRadius.all(Radius.circular(24.0))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title!,
              style: ThemeText.getDefaultTextTheme().textLabelChart,
            ),
            SizedBox(
              height: TransactionRecentConstants.totalAmountPaddingTop,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _total.toString().formatStringToCurrency(),
                  style: ThemeText.getDefaultTextTheme().textTotalMoneyChart,
                ),
                Visibility(visible: false, child: _typeIconWidget(context))
              ],
            ),
            SizedBox(
              height: TransactionRecentConstants.columnChartAmountPaddingTop,
            ),
            // Check report map is exist
            // If exist, show data
            // Else, show empty chart data
            _isDataEmpty(_dataSettleDebtSelected!)
                ? EmptyHomeChartWidget(
                    heightChart: TransactionRecentConstants.heightColumnChart,
                    listDay: _dataSettleDebtSelected!.keys.toList(),
                    continuousInit: true,
                  )
                : ColumnChartWidget(
                    TransactionRecentConstants.heightColumnChart,
                    barGroupDataMap:
                        _dataSettleDebtSelected as LinkedHashMap<int, int>,
                    continuousInit: true,
                    keyHighlight: DateTime.now().day,
                    countHorizontalLine: 4,
                  ),
          ],
        ),
      ),
    );
  }

  Widget _typeIconWidget(BuildContext context) {
    return PopupMenuButton<ColumnChartValueTypeEnum>(
        color: AppColor.white,
        onSelected: (ColumnChartValueTypeEnum newValue) {
          if (typeEnum != newValue) {
            if (index == 0) {
              BlocProvider.of<HomeChartBloc>(context)
                  .add(ChangeExpenseTypeData(newValue));
            } else if (index == 1) {
              BlocProvider.of<HomeChartBloc>(context)
                  .add(ChangeOwedTypeData(newValue));
            }
          }
        },
        itemBuilder: (context) => _popupItems,
        child: Padding(
          padding: const EdgeInsets.only(
              left: LayoutConstants.dimen_10, bottom: LayoutConstants.dimen_10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                mapChartTypeToString(typeEnum!)!,
                style: ThemeText.getDefaultTextTheme()
                    .caption
                    ?.copyWith(color: AppColor.iconColorPrimary),
              ),
              const SizedBox(
                width: 4,
              ),
              Image.asset(IconConstants.dropDownIcon),
            ],
          ),
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
}
