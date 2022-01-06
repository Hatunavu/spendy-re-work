import 'dart:convert';

import 'package:spendy_re_work/data/model/notification/push_notification_data_model.dart';
import 'package:spendy_re_work/domain/entities/notifications/push_notification_entity.dart';

class PushNotificationModel {
  PushNotificationModel({
    this.notification,
    this.data,
    this.collapseKey,
    this.messageId,
    this.sentTime,
    this.from,
    this.ttl,
  });

  final PushNotificationDataModel? notification;
  final PushNotificationDataModel? data;
  final String? collapseKey;
  final String? messageId;
  final int? sentTime;
  final String? from;
  final int? ttl;

  factory PushNotificationModel.fromRawJson(String str) =>
      PushNotificationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PushNotificationModel.fromJson(Map<String, dynamic> json) =>
      PushNotificationModel(
        notification: PushNotificationDataModel.fromJson(json['notification']),
        data: PushNotificationDataModel.fromJson(json['data']),
        collapseKey: json['collapse_key'],
        messageId: json['message_id'],
        sentTime: json['sent_time'],
        from: json['from'],
        ttl: json['ttl'],
      );

  Map<String, dynamic> toJson() => {
        'notification': notification!.toJson(),
        'data': data!.toJson(),
        'collapse_key': collapseKey,
        'message_id': messageId,
        'sent_time': sentTime,
        'from': from,
        'ttl': ttl,
      };

  factory PushNotificationModel.fromEntity(PushNotificationEntity entity) =>
      PushNotificationModel(
        notification:
            PushNotificationDataModel.fromEntity(entity.notification!),
        data: PushNotificationDataModel.fromEntity(entity.data!),
        collapseKey: entity.collapseKey,
        messageId: entity.messageId,
        sentTime: entity.sentTime,
        from: entity.from,
        ttl: entity.ttl,
      );
}
