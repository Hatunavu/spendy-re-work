import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/domain/entities/receive_notification_entity.dart';

class LocalNotifyConstants {
  static const minOfGoalID = 500;
  static const maxOfGoalID = 10000;

  static const dailyId = 0;

  static final ReceiveNotificationEntity defaultNotificationDaily =
      ReceiveNotificationEntity(
    id: dailyId,
    title: titleSpendyNotification,
    body: bodyForgetAddExpense,
  );

  static const int hourOfDailyNotification = 20;

  static const String androidChannelID = 'Local-Channel';
  static const String androidChannelDescription =
      'Spendy channel local notification';
  static const String androidChannelName = 'Spendy channel';

  static String bodyForgetAddExpense =
      translate('label.body_forget_add_expense');

  static String bodyMonthlyNotify = translate('label.body_monthly_notify');
  static const String titleSpendyNotification = 'Spendy';

  static const String titleGoalNotification = 'Spendy';
}
