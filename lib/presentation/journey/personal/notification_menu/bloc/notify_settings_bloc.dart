import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spendy_re_work/common/enums/enable_permission.dart';
import 'package:spendy_re_work/common/utils/permission_helpers.dart';
import 'package:spendy_re_work/domain/entities/user/setting_entity.dart';
import 'package:spendy_re_work/domain/entities/user/user_entity.dart';
import 'package:spendy_re_work/domain/usecases/local_notification_usecase.dart';
import 'package:spendy_re_work/domain/usecases/profile_user_usecase.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/notification_menu/bloc/notify_settings_event.dart';
import 'package:spendy_re_work/presentation/journey/personal/notification_menu/bloc/notify_settings_state.dart';

class NotifySettingsBloc
    extends Bloc<NotifySettingsEvent, NotifySettingsState> {
  final LocalNotificationUseCase localNotificationUseCase;
  final ProfileUserUseCase profileUsecase;
  final AuthenticationBloc authBloc;

  UserEntity? user;
  bool? checkPermission;

  NotifySettingsBloc(
      {required this.localNotificationUseCase,
      required this.authBloc,
      required this.profileUsecase})
      : super(NotifySettingsLoadingState());
  @override
  Stream<NotifySettingsState> mapEventToState(
      NotifySettingsEvent event) async* {
    switch (event.runtimeType) {
      case NotifyInitialEvent:
        yield* _mapNotifyInitialEventToState();
        break;
      case NotifySwitchEvent:
        yield* _mapNotifySwitchEventToState(event as NotifySwitchEvent);
        break;
    }
  }

  Stream<NotifySettingsState> _mapNotifyInitialEventToState() async* {
    final UserEntity? userEntity =
        await profileUsecase.getUserProfile(authBloc.userEntity.uid!);
    yield NotifySettingsInitialState(
      isEnableNotification: userEntity?.setting?.notification,
      permissionState: PermissionState.none,
    );
  }

  Stream<NotifySettingsState> _mapNotifySwitchEventToState(
      NotifySwitchEvent event) async* {
    final currentState = state;
    if (currentState is NotifySettingsInitialState) {
      PermissionState notifyPermissionState = PermissionState.none;
      final checkPermission =
          await PermissionHelpers.isPermissionGranted(Permission.notification);
      // #1: Check notification permission is access or not
      if (checkPermission) {
        // #2.1: Notification setting
        notifyPermissionState = PermissionState.enable;
        await _notificationSettingChanged(
          event.notify,
        );
      } else {
        // #2.2: Open Re apply permission dialog
        notifyPermissionState = PermissionState.disable;
      }
      yield NotifySettingsInitialState();
      yield NotifySettingsInitialState(
        isEnableNotification: checkPermission && event.notify, //:false,
        permissionState: notifyPermissionState,
      );
    }
  }

  Future _notificationSettingChanged(bool notify) async {
    try {
      // #1: Check Notification setting is enable or not
      if (notify) {
        await localNotificationUseCase.setUpAllNotification(user!.uid!);
      } else {
        await localNotificationUseCase.turnOff();
      }
      final UserEntity? userEntity =
          await profileUsecase.getUserProfile(authBloc.userEntity.uid!);
      userEntity?.update(setting: SettingEntity(notification: notify));
      await profileUsecase.updateProfile(userEntity!);
    } catch (e) {
      rethrow;
    }
  }
}
