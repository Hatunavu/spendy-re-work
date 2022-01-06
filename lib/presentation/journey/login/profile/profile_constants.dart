import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class ProfileConstants {
  static String titleNewAccount = translate('label.lets_get_started');
  static String header =
      translate('label.complete_to_register_your_finance_account');
  static String nameHintText = translate('label.full_name');
  static String errorMsg = translate('label.please_enter_your_full_name');
  static String createTitleBtn = translate('label.done');
  static String avatarText = translate('label.avatar');

  static final avatarPadding = 12.w;
  static final fzNewAccount = 30.sp;

  static double formPaddingTop30 = 30.h;
  static double formPaddingTop = 50.h;
}
