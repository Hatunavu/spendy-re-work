import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter/cupertino.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class FilterConstants {
  static String filterScreenTitle = translate('label.filter_screen_title');
  static String categoryOptionName = translate('label.category_option_name');
  static String timeOptionName = translate('label.time_option_name');
  static String groupTypeOptionName = translate('label.group_type_option_name');
  static String expenseRangeOptionName =
      translate('label.expense_range_option_name');
  static String deselectExpenseRange =
      translate('label.deselect_expense_range');
  static String deleteButton = translate('label.delete_button');
  static String resetButton = translate('label.reset_button');
  static final String transaction = translate('label.transaction_lower');

  static const SizedBox spacingBetweenIconAndTitle = SizedBox(width: 16);
  static double spacingBottom = 100.h;
  static const double spacingBetweenOptions = 18;
  static const double buttonHeight = 40;
  static const double minExpenseRange = 0;
  static const double maxExpenseRange = 300000000;
  static const int lastRangeInfinity = 999999999999;
  static final double paddingTop18 = 18.h;
}
