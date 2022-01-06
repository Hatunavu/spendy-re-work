import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/shared_preference_keys_constants.dart';
import 'package:spendy_re_work/common/firebase_setup.dart';
import 'package:spendy_re_work/common/injector/injector.dart';
import 'package:spendy_re_work/common/injector/injector_config.dart';
import 'package:spendy_re_work/common/local_preferences/local_preferences.dart';
import 'package:spendy_re_work/data/datasources/remote/noti_datasource.dart';
import 'package:spendy_re_work/data/model/notification/notification_model.dart';
import 'package:spendy_re_work/data/model/notification/push_notification_model.dart';
import 'package:spendy_re_work/domain/entities/notifications/push_notification_entity.dart';
import 'package:spendy_re_work/presentation/bloc/push_notification_bloc/bloc.dart';

class PushNotificationService {
  FirebaseMessaging? _firebaseMessaging;
  Function(String)? handleNotificationTap;
  String? _fcmToken;
  String? _payLoad;
  BuildContext? context;
  static final PushNotificationService _singleton =
      PushNotificationService._internal();

  factory PushNotificationService() {
    return _singleton;
  }

  PushNotificationService._internal() {
    _firebaseMessaging = FirebaseMessaging.instance;
  }

  Future initialize(BuildContext context,
      {Function(String)? handleNotificationTap}) async {
    this.context = context;
    this.handleNotificationTap = handleNotificationTap!;
    await _fcmInitialization();
  }

  Future _fcmInitialization() async {
    _fcmToken ??= await _firebaseMessaging!.getToken();
    subscribeToTopic();
    final RemoteMessage? initMessage =
        await _firebaseMessaging!.getInitialMessage();
    if (initMessage != null) {
      _payLoad = jsonEncode(initMessage);
      final pushNotificationModel =
          PushNotificationModel.fromRawJson(_payLoad!);
      BlocProvider.of<PushNotificationBloc>(context!).add(
          NotificationOnTapEvent(
              PushNotificationEntity.parseEntity(pushNotificationModel)));
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _payLoad = getNotificationContent(message);
      final pushNotificationModel =
          PushNotificationModel.fromRawJson(_payLoad!);
      BlocProvider.of<PushNotificationBloc>(context!).add(
          OnReceivePushNotificationEvent(
              PushNotificationEntity.parseEntity(pushNotificationModel)));
    });
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _payLoad = getNotificationContent(message);
      handleNotificationTap!(_payLoad!);
    });
  }

  void unsubscribeFromTopic() {
    _firebaseMessaging!.unsubscribeFromTopic('global');
  }

  void subscribeToTopic() {
    _firebaseMessaging!.subscribeToTopic('global').then((value) {});
  }

  String? getFcmToken() => _fcmToken;

  Future deleteToken() async {
    _fcmToken = null;
    await _firebaseMessaging!.deleteToken();
  }
}

String getNotificationContent(RemoteMessage? message) {
  if (message == null) {
    return 'RemoteMessage is Null';
  }
  final body = {
    'notification': {
      'title': message.notification!.title,
      'body': message.notification!.body,
    },
    'data': message.data,
    'collapse_key': message.collapseKey,
    'message_id': message.messageId,
    'sent_time': message.sentTime!.millisecondsSinceEpoch,
    'from': message.from,
    'ttl': message.ttl,
  };
  return jsonEncode(body);
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final notificationModel = NotificationModel.fromRemoteMessage(message);
  InjectorConfig.setup();
  final setupFirebaseDB = Injector.resolve<SetupFirebaseDatabase>();
  await setupFirebaseDB.init();
  final localPreferences = Injector.resolve<LocalPreferences>();
  await localPreferences.init();
  final dataSource = Injector.resolve<NotificationDataSource>();
  final uid = localPreferences.get(SharedPreferenceKeys.userId);
  await dataSource.createNotification(uid, notificationModel);
}
