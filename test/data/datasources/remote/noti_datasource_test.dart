import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spendy_re_work/common/firebase_setup.dart';
import 'package:spendy_re_work/common/injector/injector.dart';
import 'package:spendy_re_work/common/injector/injector_config.dart';
import 'package:spendy_re_work/data/datasources/remote/noti_datasource.dart';
import 'package:spendy_re_work/data/model/notification/notification_model.dart';
import 'package:spendy_re_work/domain/entities/notifications/notification_entity.dart';

void main() async{
  InjectorConfig.setup();
  WidgetsFlutterBinding.ensureInitialized();
  final setupFirebaseDB = SetupFirebaseDatabase();
  await setupFirebaseDB.init();
  NotificationDataSource dataSource = NotificationDataSource(setupFirebaseDatabase: setupFirebaseDB);
  group('test get notification', (){
    test('get system notification', ()async{
      String uid = '2NC7lWGJMQceFhD01bB2otEZg5r1';
      List<NotificationModel> notificationModels = await dataSource.getNotification(uid, 1234567891);
      List<NotificationEntity> notificationEntities = notificationModels;
      print('System notification');
      print('$notificationEntities');
    });
    test('get user notification', ()async{
      String uid = '2NC7lWGJMQceFhD01bB2otEZg5r1';
      List<NotificationModel> notificationModels =await dataSource.getNotification(uid, 1234567891);
      List<NotificationEntity> notificationEntities = notificationModels;
      print('User notification');
      print('$notificationEntities');
    });
  });
}