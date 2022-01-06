import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class ReportPageConstants {
  static final fzTotalChart = 15.sp;
  static final fzMoneyChart = 20.sp;

  static final paddingBody = 22.w;
  static final paddingTop = 18.h;
  // group text total - owed
  static final widthGroupTotalText = 260.w;
  static final heightGroupTotalText = 140.h;
  static final widthMoneyText = 150.w;
  static final paddingBetweenTotalText = 5.h;
  static final groupTotalTextPaddingVertical = 14.h;
  static final groupTotalTextPaddingHorizontal = 28.h;

  // chart
  static final widthCenterPieChart = 58.w;
  static final heightCenterPieChart = 63.h;
  static final widthBgCenterChart = 100.w;
  static final heightBgCenterChart = 100.h;
  static final chartPiePaddingLeft = 8.h;
  static final chartPiePaddingVertical = 20.h;
  static final heightBarChart = 200.h;
  static final sizePieChart = 160.h;

  // expense item
  static final widthMoneyTextItem = 108.w;

  static final navigatorPaddingSpace = 8.w;

  static String textTotalExpense = translate('label.total_expense');
  static String textOwed = translate('label.owed');
  static String titleReport = translate('label.report');
  static String titleLineChart = translate('label.title_line_chart');
  static final String createFirstExpense =
      translate('label.add_the_first_expense');
}
