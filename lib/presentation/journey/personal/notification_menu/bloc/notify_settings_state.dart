import 'package:spendy_re_work/common/enums/enable_permission.dart';
import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';

abstract class NotifySettingsState extends Equatable {}

class NotifySettingsLoadingState extends NotifySettingsState {
  @override
  List<Object> get props => [];
}

class NotifySettingsInitialState extends NotifySettingsState {
  final bool? isEnableNotification;
  final PermissionState? permissionState;

  NotifySettingsInitialState({this.isEnableNotification, this.permissionState});

  NotifySettingsInitialState copyWith(
      {bool? notify, PermissionState? permissionState}) {
    return NotifySettingsInitialState(
      isEnableNotification: notify ?? isEnableNotification,
      permissionState: permissionState ?? permissionState,
    );
  }

  @override
  List<Object?> get props => [isEnableNotification, permissionState];
}
