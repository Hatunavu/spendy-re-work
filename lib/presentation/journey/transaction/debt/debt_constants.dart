import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class DebtConstants {
  static String debtText = translate('label.debts');
  static String settleDebtText = translate('label.settle_debts');
  static String meText = translate('label.(me)');
  static String sendMoneyTo = translate('label.send_money_to');
  static String shareSettleDebtTitle = translate('label.share_settle_debts');
  static String cancelTitle = translate('label.cancel');
  static String applyTitle = translate('label.apply');
  static String owesText = translate('label.owes');

  static double settleDebtFz = 20.sp;
  static double minWidthDebtAmount = 100.w;
  static double maxWidthDebtAmount = 168.w;

  static double paddingVertical16 = 16.h;
  static double paddingVertical5 = 5.h;
  static double paddingHorizontal16 = 14.w;

  static double thickessLine = LayoutConstants.dimen_0_3;
}
