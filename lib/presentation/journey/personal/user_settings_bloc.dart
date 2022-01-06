import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spendy_re_work/common/enums/enable_permission.dart';
import 'package:spendy_re_work/common/utils/permission_helpers.dart';
import 'package:spendy_re_work/domain/entities/user/security_entity.dart';
import 'package:spendy_re_work/domain/entities/user/setting_entity.dart';
import 'package:spendy_re_work/domain/usecases/local_notification_usecase.dart';
import 'package:spendy_re_work/domain/usecases/profile_user_usecase.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import '../../../../common/constants/route_constants.dart';

part 'user_settings_event.dart';

part 'user_settings_state.dart';

class UserSettingsBloc extends Bloc<UserSettingsEvent, UserSettingsState> {
  final ProfileUserUseCase profileUserUseCase;
  final AuthenticationBloc authenticationBloc;
  final LocalNotificationUseCase localNotificationUseCase;

  SecurityEntity _currentUserSetting =
      SecurityEntity(isBio: false, isPin: false, pinCode: '');

  SecurityEntity? _previousSetting;

  UserSettingsBloc(
      {required this.profileUserUseCase,
      required this.localNotificationUseCase,
      required this.authenticationBloc})
      : super(UserSettingsDisplayed(
            SecurityEntity(isBio: false, isPin: false, pinCode: '')));

  @override
  Stream<UserSettingsState> mapEventToState(
    UserSettingsEvent event,
  ) async* {
    if (event is FetchUserSettings) {
      yield* _mapFetchUserSettingsToState(event);
    } else if (event is SettingChange) {
      yield* _mapSettingsChangeToState(event);
    } else if (event is ConfigUserSettingsFailedEvent) {
      yield* _mapConfigUserSettingsFailedEventToState();
    } else if (event is DenyNotificationSettings) {
      yield* _mapDenyNotificationSettingsToState(event);
    }
  }

  Stream<UserSettingsState> _mapFetchUserSettingsToState(
      FetchUserSettings event) async* {
    final uid = authenticationBloc.userEntity.uid;
    if (uid != null) {
      _currentUserSetting = authenticationBloc.userEntity.setting!.security!;
      _previousSetting = _currentUserSetting;
    }
    yield UserSettingsDisplayed(_currentUserSetting, isPushToScreen: false);
  }

  Stream<UserSettingsState> _mapSettingsChangeToState(
      SettingChange event) async* {
    final currentState = state;
    const String routeName = '';
    bool isPushToScreen = false;
    final uid = authenticationBloc.userEntity.uid;
    if (currentState is UserSettingsDisplayed) {
      PermissionState notifyPermissionState = PermissionState.none;
      yield currentState.copyWith(_currentUserSetting,
          notifyPermissionState: notifyPermissionState);
      if (event.currentRoute != null &&
          event.currentRoute == RouteList.notificationMenu) {
        // Notification setting
        final checkPermission = await PermissionHelpers.isPermissionGranted(
            Permission.notification);
        // #1: Check notification permission is access or not
        if (checkPermission) {
          // #2.1: Notification setting
          notifyPermissionState = PermissionState.enable;
          await _notificationSettingChanged(
            uid!,
            event.userSettings!,
          );
        } else {
          // #2.2: Open Re apply permission dialog
          notifyPermissionState = PermissionState.disable;
        }
      } else {
        await _securitySettingChanged(uid!, event.userSettings!);
        // routeName = await profileUserUseCase.pushRouteName(_currentUserSetting);
        isPushToScreen = true;
      }

      yield currentState.copyWith(_currentUserSetting,
          isPushToScreen: isPushToScreen,
          routeName: routeName,
          notifyPermissionState: notifyPermissionState);
    }
  }

  Future _securitySettingChanged(
      String uid, SecurityEntity userSettings) async {
    _previousSetting = _currentUserSetting;
    _currentUserSetting = await profileUserUseCase.mapCurrentUserSettings(
        uid: uid, settings: userSettings, currentSettings: _currentUserSetting);
  }

  Future _notificationSettingChanged(
      String uid, SecurityEntity userSettings) async {
    _previousSetting = _currentUserSetting;
    _currentUserSetting = userSettings;
    try {
      // #1: Check Notification setting is enable or not
      // if (userSettings.enableNotification) {
      //   await localNotificationUseCase.setUpAllNotification(uid);
      // } else {
      //   await localNotificationUseCase.turnOff();
      // }
      final user = authenticationBloc.userEntity;
      user.update(
          setting: SettingEntity(
              notification: user.setting?.notification,
              security: _currentUserSetting));
      await profileUserUseCase.updateProfile(user);
    } catch (e) {
      rethrow;
    }
  }

  Stream<UserSettingsState> _mapConfigUserSettingsFailedEventToState() async* {
    yield ResetSettingState();
    final uid = authenticationBloc.userEntity.uid;
    _currentUserSetting = _previousSetting!;
    _currentUserSetting = await profileUserUseCase.mapCurrentUserSettings(
        uid: uid,
        settings: _previousSetting,
        currentSettings: _currentUserSetting);
    yield UserSettingsDisplayed(_currentUserSetting, isPushToScreen: false);
  }

  Stream<UserSettingsState> _mapDenyNotificationSettingsToState(
      DenyNotificationSettings event) async* {
    final currentState = state;
    if (currentState is UserSettingsDisplayed) {
      yield currentState.copyWith(event.userSettings,
          notifyPermissionState: PermissionState.none);
    }
  }
}
