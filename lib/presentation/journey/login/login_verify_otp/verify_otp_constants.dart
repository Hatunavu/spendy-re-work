import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class VerifyOtpConstant {
  static const String keyArgPhone = 'phone';
  static const String keyArgPhoneCode = 'phone_code';
  static const String keyArgVerifyId = 'verify_id';

  static const timeOutOTPCodeAutoRetrievalSecond = 30;
  static const timeOutResendSecond = 300;

// Padding
  static double paddingTopBody = 112.h;
  static double paddingTopSubTit = 32.h;
  static double paddingTopNumberField = 42.h;
  static double paddingBottomNumberField = 115.h;
  static double padding_24h = 24.h;

  // Size
  static double fieldWidth = 50.w;

  // Font size
  static double fzTitle = 27.sp;
  static double fzBody = 15.sp;
  static double fzTextField = 40.sp;

  // Multiple language
  static String textTitle = translate('label.verification_code');
  static String textSubTit =
      translate('label.please_type_the_verification_code_sent');
  static String textTitleAlert = translate('label.notification');
  static String textButtonAlert = translate('label.ok');
  static String textBodyAlert =
      translate('label.otp_code_is_incorrect._please_try_again!');
}
