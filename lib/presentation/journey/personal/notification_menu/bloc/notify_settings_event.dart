import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';

abstract class NotifySettingsEvent extends Equatable {}

class NotifyInitialEvent extends NotifySettingsEvent {
  @override
  List<Object> get props => [];
}

class NotifySwitchEvent extends NotifySettingsEvent {
  final bool notify;

  NotifySwitchEvent({required this.notify});

  @override
  List<Object> get props => [notify];
}
