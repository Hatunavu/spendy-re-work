import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';

class UnreadNotificationState extends Equatable {
  final bool? isUnread;

  UnreadNotificationState({this.isUnread});

  factory UnreadNotificationState.init() =>
      UnreadNotificationState(isUnread: false);

  UnreadNotificationState update({bool? isUnread}) =>
      UnreadNotificationState(isUnread: isUnread ?? this.isUnread);

  @override
  List<Object?> get props => [isUnread];
}
