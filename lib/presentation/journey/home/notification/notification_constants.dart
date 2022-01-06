import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class NotificationConstants {
  static const String readAllText = 'Read All';
  static const String keyNotiMsg = 'key_msg';
  static const String keyNotiMsg1 = 'key_msg1';
  static String notiTitle = translate('label.notification');
  static String textLess = translate('label.less_than');
  static String textMore = translate('label.more_than');

  static double iconsSize = 7.w;
  static double height5 = 5.h;
  static double height8 = 8.h;
  static double height10 = 10.h;
  static double height18 = LayoutConstants.dimen_18.h;
  static final double paddingTop18 = 18.h;

  static double wight5 = LayoutConstants.dimen_5.w;

  /// Notification type
  static const String spentType = 'spent';
  static const String debtType = 'debt';
  static const String serviceType = 'service';
  static const String goalType = 'goal';

  /// map key message notification
  static const String spentMsgKey = 'spent-msg';
  static const String debtMsgKey = 'debt-msg';
  static const String spentAmountMsgKey = 'spent-amount-msg';
  static const String debtAmountMsgKey = 'debt-amount-msg';
  static const String serviceMsgKey = 'service-msg';
  static const String goalMsgKey = 'goal-msg';
  static final double minHeightNotiItem = 18.h;
}
