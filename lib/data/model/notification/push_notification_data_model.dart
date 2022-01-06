import 'dart:convert';

import 'package:spendy_re_work/domain/entities/notifications/push_notification_data_entity.dart';

class PushNotificationDataModel {
  PushNotificationDataModel({
    this.body,
    this.title,
    this.routeTo,
    this.message,
    this.type,
    this.createAt,
    this.showTime,
    this.clickAction,
  });

  final String? body;
  final String? title;
  final String? routeTo;
  final String? message;
  final String? type;
  final String? createAt;
  final String? showTime;
  final String? clickAction;

  factory PushNotificationDataModel.fromRawJson(String str) =>
      PushNotificationDataModel.fromJson(jsonDecode(str));

  String toRawJson() => jsonEncode(toJson());

  factory PushNotificationDataModel.fromJson(Map<String, dynamic> json) =>
      PushNotificationDataModel(
        body: json['body'],
        title: json['title'],
        routeTo: json['route_to'],
        message: json['message'],
        type: json['type'],
        clickAction: json['click_action'],
      );

  Map<String, dynamic> toJson() => {
        'body': body,
        'title': title,
        'route_to': routeTo,
        'message': message,
        'type': type,
        'click_action': clickAction,
      };

  factory PushNotificationDataModel.fromEntity(
          PushNotificationDataEntity entity) =>
      PushNotificationDataModel(
        body: entity.body,
        title: entity.title,
        routeTo: entity.routeTo,
        message: entity.message,
        type: entity.type,
        clickAction: entity.clickAction,
      );
}
