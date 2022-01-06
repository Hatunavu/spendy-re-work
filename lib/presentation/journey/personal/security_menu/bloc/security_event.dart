import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/domain/entities/user/security_entity.dart';

abstract class SecurityEvent extends Equatable {}

class SecurityInitialEvent extends SecurityEvent {
  @override
  List<Object> get props => [];
}

class RefreshSecurityDataEvent extends SecurityEvent {
  final SecurityEntity securitySettings;

  RefreshSecurityDataEvent({required this.securitySettings});

  @override
  List<Object> get props => [securitySettings];
}

class SecuritySwitchEvent extends SecurityEvent {
  final SecurityEntity security;

  SecuritySwitchEvent({required this.security});

  @override
  List<Object> get props => [security];
}

class ConfigUserSettingsFailedEvent extends SecurityEvent {
  @override
  List<Object> get props => [];
}
