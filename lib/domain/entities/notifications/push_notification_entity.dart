import 'package:spendy_re_work/data/model/notification/push_notification_model.dart';
import 'package:spendy_re_work/domain/entities/notifications/push_notification_data_entity.dart';

class PushNotificationEntity {
  PushNotificationDataEntity? notification;
  PushNotificationDataEntity? data;
  String? collapseKey;
  String? messageId;
  int? sentTime;
  String? from;
  int? ttl;

  PushNotificationEntity({
    this.notification,
    this.data,
    this.collapseKey,
    this.messageId,
    this.sentTime,
    this.from,
    this.ttl,
  });

  PushNotificationEntity.parseEntity(PushNotificationModel model) {
    notification = (model.notification != null)
        ? PushNotificationDataEntity.parseEntity(model.notification!)
        : null;
    data = (model.data) != null
        ? PushNotificationDataEntity.parseEntity(model.data!)
        : null;
    collapseKey = model.collapseKey;
    messageId = model.messageId;
    sentTime = model.sentTime;
    from = model.from;
    ttl = model.ttl;
  }
  PushNotificationModel toModel() {
    return PushNotificationModel.fromEntity(this);
  }

  @override
  String toString() {
    return 'PushNotificationEntity{notification: $notification, data: $data, collapseKey: $collapseKey, messageId: $messageId, sentTime: $sentTime, from: $from, ttl: $ttl}';
  }
}
