import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:spendy_re_work/common/enums/notification_enum/notification_type.dart';
import 'package:spendy_re_work/domain/entities/notifications/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel(
      {String? id,
      int? createAt,
      String? key,
      String? message,
      int? showtime,
      String? type,
      bool? isRead})
      : super(
            id: id!,
            createAt: createAt!,
            type: type!,
            key: key!,
            message: message!,
            showtime: showtime!,
            isRead: isRead!);

  factory NotificationModel.fromJson(Map<String, dynamic> json, String id) =>
      NotificationModel(
          id: id,
          createAt: json['create_at'],
          key: json['key'],
          message: json['msg'],
          showtime: json['show_time'],
          type: json['type'],
          isRead: json['is_read']);

  factory NotificationModel.fromJsonString(Map<String, dynamic> json) {
    return NotificationModel(
        id: json['id'] ?? '',
        createAt: json['create_at'] ?? '',
        key: json['key'] ?? '',
        message: json['msg'] ?? '',
        showtime: json['show_time'] ?? '',
        type: json['type'] ?? '',
        isRead: json['is_read'] ?? '');
  }

  factory NotificationModel.fromRemoteMessage(RemoteMessage message) =>
      NotificationModel(
          createAt: message.sentTime!.millisecondsSinceEpoch,
          message: message.notification!.body,
          showtime: message.sentTime!.millisecondsSinceEpoch,
          type: NotiType.system.name,
          isRead: false);

  Map<String, dynamic> toJson() => {
        'create_at': createAt,
        'key': key,
        'msg': message,
        'show_time': showtime,
        'type': type,
        'is_read': isRead
      };
}
