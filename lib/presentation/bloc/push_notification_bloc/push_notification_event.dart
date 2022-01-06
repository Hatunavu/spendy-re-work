import 'package:equatable/equatable.dart';
import 'package:spendy_re_work/domain/entities/notifications/push_notification_entity.dart';

abstract class PushNotificationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitEvent extends PushNotificationEvent {}

class NotificationOnTapEvent extends PushNotificationEvent {
  final PushNotificationEntity pushNotificationEntity;

  NotificationOnTapEvent(this.pushNotificationEntity);
}

class OnGetCountUnreadNotificationEvent extends PushNotificationEvent {}

class OnReceivePushNotificationEvent extends PushNotificationEvent {
  final PushNotificationEntity pushNotificationEntity;

  OnReceivePushNotificationEvent(this.pushNotificationEntity);
}

class LogoutEvent extends PushNotificationEvent {
  LogoutEvent();
  @override
  List<Object> get props => [];
}

class LogInEvent extends PushNotificationEvent {
  LogInEvent();
  @override
  List<Object> get props => [];
}
