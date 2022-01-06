import 'package:equatable/equatable.dart';
import 'package:spendy_re_work/domain/entities/receive_notification_entity.dart';

abstract class NotificationManagerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitEvent extends NotificationManagerEvent {}

class ShowNotificationEvent extends NotificationManagerEvent {
  final ReceiveNotificationEntity receiveNotificationEntity;

  ShowNotificationEvent(this.receiveNotificationEntity);
}
