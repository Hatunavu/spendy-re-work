import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'local_notify_constants.dart';
import 'package:spendy_re_work/domain/entities/receive_notification_entity.dart';

abstract class LocalNotifyHelper {
  Future<void> initLocalNotification(
      {Future<dynamic> onDidReceiveLocalNotification(
          int id, String? title, String? body, String? payload)?,
      required Future<dynamic> selectNotification(String? payload),
      required Future<dynamic> onLaunchAppByNotification(String? payload)?});

  Future<void> showNotification(
      ReceiveNotificationEntity showDailyNotification);

  Future<void> showDailyNotification(
      int hour, ReceiveNotificationEntity notificationEntity);

  Future<void> showScheduleNotification(
      DateTime dateTime, ReceiveNotificationEntity notificationEntity);

  Future<void> showMonthlyNotification(
      int day, ReceiveNotificationEntity notificationEntity);

  Future<void> cancelNotification(int id);

  Future<NotificationAppLaunchDetails> getNotificationAppLaunchDetails();
}

class LocalNotifyHelperImpl implements LocalNotifyHelper {
  LocalNotifyHelperImpl(this.flutterLocalNotificationsPlugin);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static const _androidPlatformChannelSpecifics = AndroidNotificationDetails(
      LocalNotifyConstants.androidChannelID,
      LocalNotifyConstants.androidChannelName,
      LocalNotifyConstants.androidChannelDescription,
      importance: Importance.max,
      priority: Priority.max,
      ticker: 'ticker');
  static const _iOSPlatformChannelSpecifics = IOSNotificationDetails();
  static const _platformChannelSpecifics = NotificationDetails(
      android: _androidPlatformChannelSpecifics,
      iOS: _iOSPlatformChannelSpecifics);

  /// fetch notification detail when open app via a notification
  /// Usually used for navigation to a particular screen when re-open app in background
  /// When using this method, [initLocalNotification] method must be called in the material app
  /// This method must be used in conjunction with [selectNotification] method
  Future _handleOnLaunchAppByNotification(
      Future<dynamic> onLaunchAppByNotification(String payload)) async {
    final notificationDetail =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationDetail != null &&
        notificationDetail.didNotificationLaunchApp) {
      await onLaunchAppByNotification(notificationDetail.payload!);
    }
  }

  Future _initializePlatform(
      Future Function(int id, String? title, String? body, String? payload)?
          onDidReceiveLocalNotification,
      Future Function(String? payload)? selectNotification) async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false);

    final initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );
  }

  @override
  Future<NotificationAppLaunchDetails> getNotificationAppLaunchDetails() async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    return notificationAppLaunchDetails!;
  }

  Future _initScheduleTime() async {
    final timezone = await FlutterNativeTimezone.getLocalTimezone();
    // init schedule time
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(timezone));
  }

  Future _requestIOSPermission() async {
    final bool? result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    return result;
  }

  @override
  Future<void> showNotification(
      ReceiveNotificationEntity showDailyNotification) async {
    await flutterLocalNotificationsPlugin.show(
      showDailyNotification.id,
      showDailyNotification.title,
      showDailyNotification.body,
      _platformChannelSpecifics,
      payload: showDailyNotification.payload,
    );
  }

  @override
  Future<void> showDailyNotification(
      int hour, ReceiveNotificationEntity showDailyNotification) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        showDailyNotification.id,
        showDailyNotification.title,
        showDailyNotification.body,
        _nextInstanceAtHour(hour)!,
        _platformChannelSpecifics,
        payload: showDailyNotification.payload, //?? '',
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  tz.TZDateTime? _nextInstanceAtHour(int hour) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  @override
  Future<void> showScheduleNotification(
      DateTime dateTime, ReceiveNotificationEntity notificationEntity) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)),
        const NotificationDetails(
            android: AndroidNotificationDetails('your channel id',
                'your channel name', 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  tz.TZDateTime _nextInstanceMonthly(int day) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, day);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = tz.TZDateTime(tz.local, now.year, now.month + 1, day);
    }
    return scheduledDate;
  }

  // cancel Notification methoud
  @override
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  @override
  Future<void> showMonthlyNotification(
      int day, ReceiveNotificationEntity? notificationEntity) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationEntity!.id,
        notificationEntity.title,
        notificationEntity.body,
        _nextInstanceMonthly(day),
        _platformChannelSpecifics,
        payload: notificationEntity.payload, //??'',
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  @override
  Future<void> initLocalNotification(
      {Future Function(int id, String? title, String? body, String? payload)?
          onDidReceiveLocalNotification,
      Future Function(String? payload)? selectNotification,
      Future Function(String? payload)? onLaunchAppByNotification}) async {
    await _initializePlatform(
        onDidReceiveLocalNotification, selectNotification);
    await _requestIOSPermission();
    await _initScheduleTime();
    if (onLaunchAppByNotification != null) {
      await _handleOnLaunchAppByNotification(onLaunchAppByNotification);
    }
  }
}
