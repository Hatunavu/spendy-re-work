import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';

abstract class UnreadNotificationEvent extends Equatable {}

class UnreadNotificationInitEvent extends UnreadNotificationEvent {
  @override
  List<Object> get props => [];
}

class ListenUnreadNotificationRealTimeEvent extends UnreadNotificationEvent {
  final bool isUnread;

  ListenUnreadNotificationRealTimeEvent(this.isUnread);

  @override
  List<Object> get props => [];
}
