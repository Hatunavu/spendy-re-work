import 'package:spendy_re_work/common/enums/notification_enum/notification_type.dart';
import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/domain/entities/notifications/notification_entity.dart';

abstract class NotiEvent extends Equatable {}

class NotiInitialEvent extends NotiEvent {
  final bool isMore;

  NotiInitialEvent({this.isMore = false});
  @override
  List<Object> get props => [];
}

class ReadAllEvent extends NotiEvent {
  @override
  List<Object> get props => [];
}

class ReadNotiEvent extends NotiEvent {
  final NotificationEntity notification;

  ReadNotiEvent(this.notification);

  @override
  List<Object> get props => [notification];
}

class LoadMoreNotificationEvent extends NotiEvent {
  @override
  List<Object> get props => [];
}

class CreateNotificationEvent extends NotiEvent {
  final String? categoryName;
  final String? goalId;
  final int? showTime;
  final String? messages;
  final NotiType? type;
  final int? createTime;

  CreateNotificationEvent(
      {this.categoryName,
      this.goalId,
      this.showTime,
      this.messages,
      this.type,
      this.createTime});

  @override
  List<Object?> get props =>
      [categoryName, goalId, showTime, messages, type, createTime];
}

class UpdateGoalNotificationEvent extends NotiEvent {
  final String goalId;
  final int showTime;

  UpdateGoalNotificationEvent(this.goalId, this.showTime);
  @override
  List<Object> get props => [];
}

class DeleteGoalNotiEvent extends NotiEvent {
  final String? goalID;

  DeleteGoalNotiEvent({this.goalID});

  @override
  List<Object?> get props => [goalID];
}

class ListenRealTimeNotificationEvent extends NotiEvent {
  final List<NotificationEntity> notifications;

  ListenRealTimeNotificationEvent(this.notifications);
  @override
  List<Object> get props => [notifications];
}
