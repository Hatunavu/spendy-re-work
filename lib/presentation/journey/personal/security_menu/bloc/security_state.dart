import 'package:local_auth/local_auth.dart';
import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/domain/entities/user/security_entity.dart';

abstract class SecurityState extends Equatable {}

class SecurityLoadingState extends SecurityState {
  @override
  List<Object> get props => [];
}

class SecurityInitialState extends SecurityState {
  final SecurityEntity security;
  final bool isPushToScreen;
  final String routeName;
  final BiometricType? biometricType;

  SecurityInitialState(
      {required this.security,
      required this.isPushToScreen,
      required this.routeName,
      this.biometricType});

  SecurityInitialState copyWith(
          {SecurityEntity? security,
          bool? isPushToScreen,
          String? routeName,
          BiometricType? biometricType}) =>
      SecurityInitialState(
          security: security ?? this.security,
          isPushToScreen: isPushToScreen ?? this.isPushToScreen,
          routeName: routeName ?? this.routeName,
          biometricType: biometricType ?? this.biometricType);

  @override
  List<Object?> get props =>
      [security, isPushToScreen, this, routeName, biometricType];
}
