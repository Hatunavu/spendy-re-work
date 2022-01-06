import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class SecurityMenuConstants {
  static double paddingLeft = 28.w;
  static double paddingTop = 18.h;

  static double heightSwitch = 19.h;
  static double scaleSwitch = 0.7;

  static String textTitle = translate('label.security');
  static String textPassCodeMenu = translate('label.pass_code');
  static String textFaceIDMenu = translate('label.face_id');
  static String textFingerPrintMenu = translate('label.finger_print');

  /// KEY
  static const bool isDeletePassCode = true;
  static const String deletePassCodeKey = 'delete_pass_code_key';
}
