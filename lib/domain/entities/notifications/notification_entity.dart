import 'package:spendy_re_work/data/model/notification/notification_model.dart';

class NotificationEntity {
  final String? id;
  final int? createAt;
  final String? key;
  final String? message;
  final int? showtime;
  final String? type;
  final bool? isRead;

  NotificationEntity(
      {this.id,
      this.createAt,
      this.key,
      this.message,
      this.showtime,
      this.type,
      this.isRead});

  factory NotificationEntity.normal() => NotificationEntity(
      id: '',
      createAt: 0,
      key: '',
      message: '',
      showtime: 0,
      type: '',
      isRead: false);

  NotificationModel toModel() => NotificationModel(
      id: id,
      createAt: createAt,
      key: key,
      message: message,
      showtime: showtime,
      type: type,
      isRead: isRead);

  NotificationEntity update(
          {String? id,
          int? createAt,
          String? key,
          String? message,
          int? showTime,
          String? type,
          bool? isRead}) =>
      NotificationEntity(
          id: id ?? this.id,
          createAt: createAt ?? this.createAt,
          key: key ?? this.key,
          message: message ?? this.message,
          showtime: showTime ?? showtime,
          type: type ?? this.type,
          isRead: isRead ?? this.isRead);

  @override
  String toString() {
    return 'NotificationEntity{id: $id, createAt: $createAt, key: $key, message: $message, showtime: $showtime, type: $type, isRead: $isRead}';
  }
}
