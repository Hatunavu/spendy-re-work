import 'package:spendy_re_work/common/utils/notification_helpers/local_notify_constants.dart';
import 'package:spendy_re_work/common/utils/notification_helpers/local_notify_helper.dart';
import 'package:spendy_re_work/domain/entities/receive_notification_entity.dart';
import 'package:spendy_re_work/domain/repositories/noti_repository.dart';
import 'package:spendy_re_work/domain/repositories/user_repository.dart';

class LocalNotificationUseCase {
  final LocalNotifyHelper localNotifyHelper;
  final NotificationRepository notificationRepository;
  final UserRepository userRepo;

  LocalNotificationUseCase(
      {required this.localNotifyHelper,
      required this.userRepo,
      required this.notificationRepository});

  Future<void> initLocalNotification(
      {Future<dynamic> onDidReceiveLocalNotification(
          int? id, String? title, String? body, String? payload)?,
      Future<dynamic> selectNotification(String? payload)?,
      Future<dynamic> onLaunchAppByNotification(String? payload)?}) async {
    await localNotifyHelper.initLocalNotification(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification,
        selectNotification: selectNotification!,
        onLaunchAppByNotification: onLaunchAppByNotification);
  }

  Future setUpAllNotification(String uid) async {
    await setupDailyNotification();
  }

  Future setupDailyNotification() async {
    await localNotifyHelper.showDailyNotification(
        LocalNotifyConstants.hourOfDailyNotification,
        LocalNotifyConstants.defaultNotificationDaily);
    // await localNotifyHelper.showScheduleNotification(
    //     DateTime.now(), LocalNotifyConstants.defaultNotificationDaily);
  }

  Future showNotification(
      ReceiveNotificationEntity receiveNotificationEntity) async {
    await localNotifyHelper.showNotification(receiveNotificationEntity);
  }

  Future turnOff() async {
    // dispose daily notify
    await localNotifyHelper.cancelNotification(LocalNotifyConstants.dailyId);
  }
}
