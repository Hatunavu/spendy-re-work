import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class TransactionDetailDialogConstants {
  static const double iconSize = 40;
  static double imageSize = 93.h;

  static const double spaceBetweenIcons = 6;
  static const double spaceBetweenHeaderAndContent = 26;
  static const double spaceBetweenContents = 17;

  static final double fzTitle = 20.sp;

  static String transactionDetailTitle = translate('label.transaction_detail');
  static String categoryContentTitle = translate('label.category');
  static String noteContentTitle = translate('label.note');
  static String groupContentTitle = translate('label.group');
  static String dateContentTitle = translate('label.date');
  static String amountContentTitle = translate('label.amount');
  static String backButtonTitle = translate('label.back');
  static String personalGroup = translate('label.personal');
}
