part of 'user_settings_bloc.dart';

abstract class UserSettingsEvent extends Equatable {
  const UserSettingsEvent();
}

class FetchUserSettings extends UserSettingsEvent {
  @override
  List<Object> get props => [];
}

class SettingChange extends UserSettingsEvent {
  final SecurityEntity? userSettings;
  final String? currentRoute;

  SettingChange(this.userSettings, {this.currentRoute});

  @override
  List<Object?> get props => [userSettings, currentRoute];
}

class ConfigUserSettingsFailedEvent extends UserSettingsEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}

class DenyNotificationSettings extends UserSettingsEvent {
  final SecurityEntity userSettings;

  DenyNotificationSettings(this.userSettings);
  @override
  List<Object> get props => [userSettings];
}
