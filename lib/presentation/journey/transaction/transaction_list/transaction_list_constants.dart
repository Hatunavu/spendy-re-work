import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class TransactionListConstants {
  static String appBarTitle = translate('label.transaction');
  static final String createFirstExpense =
      translate('label.add_the_first_expense');
  static final String transaction = translate('label.transaction_lower');

  static const double spaceBetweenDateAndTransaction = 10;

  static final double fzSearchText = 15.sp;

  static const double spaceBetweenSearchAndTransactionList = 10;
  static const double actionIconButtonSize = 19;
  static double iconSpacing =
      LayoutConstants.dimen_48.w + LayoutConstants.dimen_15;
  static final dividerPaddingVertical = 10.h;
  static const double searchIconSize = 24;
  static final double paddingTop18 = 18.h;
}
