import 'package:spendy_re_work/data/model/notification/push_notification_data_model.dart';

class PushNotificationDataEntity {
  PushNotificationDataEntity({
    this.body,
    this.title,
    this.routeTo,
    this.message,
    this.type,
    this.clickAction,
  });

  String? body;
  String? title;
  String? routeTo;
  String? message;
  String? type;
  String? clickAction;

  PushNotificationDataEntity.parseEntity(PushNotificationDataModel model) {
    body = model.body;
    title = model.title;
    routeTo = model.routeTo;
    message = model.message;
    type = model.type;
    clickAction = model.clickAction;
  }

  PushNotificationDataModel toModel() {
    return PushNotificationDataModel.fromEntity(this);
  }

  @override
  String toString() {
    return 'PushNotificationDataEntity{body: $body, title: $title, routeTo: $routeTo, message: $message, type: $type, clickAction: $clickAction}';
  }
}
