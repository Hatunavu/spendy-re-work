import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class TransactionRecentConstants {
  static String transactionsTitle = translate('label.transactions');
  static String viewAllTitle = translate('label.view_all');
  static String textTotal = translate('label.total_expense');
  static String textOwned = translate('label.owned');
  static String textDaily = translate('label.daily');
  static String textWeek = translate('label.week');
  static final String transaction = translate('label.transaction_lower');

  static final double heightContainerChart = 270.h;
  static final double heightColumnChart = 125.h;
  static final EdgeInsets paddingChartPage = EdgeInsets.fromLTRB(21.w, 18.h, 21.w, 18.h);
  static final EdgeInsets paddingChartContainer = EdgeInsets.fromLTRB(24.w, 12.w, 24.w, 12.w);
  static final EdgeInsets chartTitlePadding = EdgeInsets.only(top: 12.w, bottom: 10.w);
  static final double totalAmountPaddingTop = 5.h;
  static final double columnChartAmountPaddingTop = 14.h;

  static double fxRecentTransactionHeader = 18.sp;
  static double spaceBetweenHeaderAndList = 25.h;
  static double popupMenuItemHeight = 40.h;
  static final EdgeInsets admobBannerPadding = EdgeInsets.symmetric(
    vertical: 10.h,
  );
  static final double groupItemHeight = 112.h;
  static final double minGroupItemHeight = 50.h;

  static int getBannerWidth(BuildContext context) {
    return (MediaQuery.of(context).size.width - 2 * LayoutConstants.dimen_26).toInt();
  }
}
