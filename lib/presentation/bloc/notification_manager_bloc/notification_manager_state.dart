import 'package:equatable/equatable.dart';
//import 'package:spendy_re_work/domain/entities/notifications/push_notification_entity.dart';

class NotificationManagerState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitNotificationManagerState extends NotificationManagerState {}

class ShowNotificationState extends NotificationManagerState {
  final String? title;
  final String? body;

  ShowNotificationState({this.title, this.body});

  @override
  List<Object> get props => [title!, body!];
}
