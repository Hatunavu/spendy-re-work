import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class PersonalPageConstants {
  static double paddingTop = 32.h;
  static double paddingBottom = 32.h;
  static double paddingLeft = 26;
  static double paddingRight = 26;
  static double textPhonePaddingTop = 5.h;
  static double avatarPaddingRight = 16.w;
  static double menuPaddingTop = 30.h;

  static double fzName = 20.sp;
  static double fzPhone = 15.sp;

  static String textCategoryMenu = translate('label.category');
  static String group = translate('label.group');
  static String textCurrency = translate('label.currency');
  static String textNotification = translate('label.notification');
  static String textSecurity = translate('label.security');
  static String textShare = translate('label.share_friends');
  static String textHelpSupport = translate('label.help_&_support');
  static String textReview = translate('label.review_app');
  static String textPolicy = translate('label.privacy_policy');

  static String urlPolicy = 'https://acaziasoft.com/privacy-policy.html';
  static const String mailSupport = 'support@acaziasoft.com';
  static const String mailSupportTitle = 'Spendy Help and Support';
  static const String mailSupportBody = 'Spendy help & support';
  static const String shareAppMessage = 'Join with me:'
      '\nhttps://spendy.page.link/download';
  static final String rateDialogTitle = translate('label.rate_my_app_title');
  static final String rateDialogContent =
      translate('label.rate_my_app_message');
  static final String rateUs = translate('label.rate_us');
  static final String noThanks = translate('label.no_thanks');
}
