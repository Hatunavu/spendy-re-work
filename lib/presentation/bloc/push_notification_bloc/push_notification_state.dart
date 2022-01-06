import 'package:equatable/equatable.dart';
import 'package:spendy_re_work/domain/entities/notifications/push_notification_entity.dart';

class PushNotificationState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitState extends PushNotificationState {}

class NotificationOnTapState extends PushNotificationState {
  final PushNotificationEntity pushNotificationEntity;

  NotificationOnTapState(this.pushNotificationEntity);

  @override
  List<Object> get props => [pushNotificationEntity];
}

class OnGetCountUnreadNotificationState extends PushNotificationState {}

class OnReceivePushNotificationState extends PushNotificationState {
  final PushNotificationEntity? pushNotificationEntity;

  OnReceivePushNotificationState({this.pushNotificationEntity});

  @override
  List<Object> get props => [pushNotificationEntity!];
}
