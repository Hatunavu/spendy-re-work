import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class LoginPhoneNumberConstant {
  static double widthFlag = 24.w;
  static double padding = 8.w;
  static double widthBoxPick = widthFlag + 2 * padding + 2;

// Padding
  static double paddingHorizontal = 44.w;
  static double paddingBottom = 85.h;
  static double formPaddingTop = 90.h;
  static double btnLoginPaddingTop = 74.5.h;
  static double versionPaddingTop = 150.h;
  static double paddingTop = 182.h;

  // Font size
  static double fzWelcome = 37.sp;
  static double fzHintField = 15.sp;
  static double fzTextField = 16.sp;
  static double letterSpacing = -0.3.sp;
  static double fzErrorField = 15.sp;
  static double fzLoginButton = 20.sp;

  static double sizeLoginForm = 200.h;

//  static double btnLoginHeight = 41.h;
  static const packageName = 'country_list_pick';
  // Multiple language
  static String textWelcome = translate('label.welcome_to_spendy');
  static String textHideField = translate('label.enter_your_phone_number');
  static String textCountryCode = translate('label.text_country_code');
  static String textLogin = translate('label.log_in');
  static String textPhoneInvalid = translate('label.invalid_phone_number');
  static String textPhoneEmptyInvalid =
      translate('label.please_enter_the_phone_number');
  static String textTitle = translate('label.select_country_code');
  static String textSearch = translate('label.search');
  static String textLastPick = translate('label.last_pick');
  static String textSearchHint = translate('label.text_search_hint');
  static String textTitleAlert = translate('label.notification');
  static String textOk = translate('label.ok');
  static String noInternetText = translate('label.no_internet_connection');
}
