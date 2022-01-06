part of 'user_settings_bloc.dart';

abstract class UserSettingsState extends Equatable {
  const UserSettingsState();
}

class UserSettingsActionLoadingState extends UserSettingsState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class UserSettingsDisplayed extends UserSettingsState {
  final SecurityEntity userSettings;
  final bool? isPushToScreen;
  final String? routeName;
  final PermissionState notifyPermissionState;

  UserSettingsDisplayed(
    this.userSettings, {
    this.isPushToScreen = false,
    this.routeName,
    this.notifyPermissionState = PermissionState.none,
  });

  UserSettingsDisplayed copyWith(SecurityEntity userSettings,
      {bool? isPushToScreen,
      String? routeName,
      PermissionState? notifyPermissionState}) {
    return UserSettingsDisplayed(
      userSettings,
      isPushToScreen: isPushToScreen ?? this.isPushToScreen,
      routeName: routeName ?? this.routeName,
      notifyPermissionState:
          notifyPermissionState ?? this.notifyPermissionState,
    );
  }

  @override
  List<Object?> get props => [
        userSettings,
        isPushToScreen,
        notifyPermissionState,
        routeName,
      ];
}

class ResetSettingState extends UserSettingsState {
  @override
  List<Object> get props => throw UnimplementedError();
}
