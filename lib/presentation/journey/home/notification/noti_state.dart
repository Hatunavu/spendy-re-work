import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/domain/entities/goal_entity.dart';
import 'package:spendy_re_work/domain/entities/notifications/notification_entity.dart';

abstract class NotiState extends Equatable {
  final bool? isUpdate;
  final List<NotificationEntity>? notificationList;

  NotiState({this.isUpdate, this.notificationList});
}

class NotiLoadingState extends NotiState {
  @override
  List<Object> get props => [];
}

class NotiInitialState extends NotiState {
  @override
  final bool isUpdate;
  @override
  final List<NotificationEntity> notificationList;

  NotiInitialState({required this.notificationList, this.isUpdate = true})
      : super(isUpdate: isUpdate, notificationList: notificationList);

  @override
  List<Object> get props => [];
}

class LoadMoreNotificationState extends NotiState {
  @override
  final bool? isUpdate;
  @override
  final List<NotificationEntity>? notificationList;

  LoadMoreNotificationState({this.isUpdate, this.notificationList})
      : super(isUpdate: isUpdate, notificationList: notificationList);

  @override
  List<Object> get props => [];
}

class NotificationNoInternetState extends NotiState {
  @override
  List<Object> get props => [];
}

class NotificationPushToEditGoalState extends NotiState {
  final GoalEntity goalEntity;

  NotificationPushToEditGoalState(this.goalEntity);
  @override
  List<Object> get props => [goalEntity];
}

class ReadNotifiState extends NotiState {
  @override
  List<Object> get props => [];
}
