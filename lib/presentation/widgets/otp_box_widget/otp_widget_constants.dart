import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/common/utils/screen_utils.dart';

class OtpWidgetConstants {
  static const int lengthCode = 6;

  static double paddingTopNumberField = 42.h;
  static double paddingBottomNumberField = 115.h;
  static double resendPaddingTop = 24.h;

  static double rowFieldsWidth = ScreenUtil().scaleWidth;
  static double fieldWidth = 50.w;

  static double fzBody = 15.sp;

  static String textDontReceive = translate('label.text_dont_receive');
  static String textResentTimer = translate('label.text_resent_timer');
  static String textResentButton = translate('label.text_resent_button');
}
