import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/common/utils/biometric_utils.dart';
import 'package:spendy_re_work/domain/entities/user/security_entity.dart';
import 'package:spendy_re_work/domain/entities/user/user_entity.dart';
import 'package:spendy_re_work/domain/usecases/profile_user_usecase.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/security_menu/bloc/security_event.dart';
import 'package:spendy_re_work/presentation/journey/personal/security_menu/bloc/security_state.dart';

class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  final AuthenticationBloc authBloc;
  final ProfileUserUseCase profileUserUseCase;

  UserEntity? user;
  SecurityEntity? _currentSecurity = SecurityEntity.defaultSecurity();
  SecurityEntity? _previousSecurity;

  SecurityBloc({required this.authBloc, required this.profileUserUseCase})
      : super(SecurityLoadingState());

  @override
  Stream<SecurityState> mapEventToState(SecurityEvent event) async* {
    switch (event.runtimeType) {
      case SecurityInitialEvent:
        yield* _mapSecurityInitialEventToState(event as SecurityInitialEvent);
        break;
      case SecuritySwitchEvent:
        yield* _mapSecuritySwitchEventToState(event as SecuritySwitchEvent);
        break;
      case ConfigUserSettingsFailedEvent:
        yield* _mapConfigUserSettingsFailedEventToState();
        break;
    }
  }

  Stream<SecurityState> _mapSecurityInitialEventToState(
      SecurityInitialEvent event) async* {
    final user =
        await profileUserUseCase.getUserProfile(authBloc.userEntity.uid!);
    final currentState = state;
    _currentSecurity = user?.setting?.security;
    _previousSecurity = user?.setting?.security;
    final biometricType = await BioMetricUtils().getBiometricType();
    if (currentState is SecurityInitialState) {
      yield currentState.copyWith(
        security: _currentSecurity,
        routeName: '',
        isPushToScreen: false,
      );
    } else {
      yield SecurityInitialState(
          security: _currentSecurity!,
          routeName: '',
          isPushToScreen: false,
          biometricType: biometricType);
    }
  }

  Stream<SecurityState> _mapSecuritySwitchEventToState(
      SecuritySwitchEvent event) async* {
    final currentState = state;
    if (currentState is SecurityInitialState) {
      String routeName = '';
      _previousSecurity = _currentSecurity;
      _currentSecurity = await _mapCurrentUserSettings(
          settings: event.security, currentSettings: _currentSecurity);
      routeName = _pushRouteName(_currentSecurity!);
      yield currentState.copyWith(
        security: _currentSecurity,
        routeName: routeName,
        isPushToScreen: true,
      );
    }
  }

  Stream<SecurityState> _mapConfigUserSettingsFailedEventToState() async* {
    final currentState = state;
    if (currentState is SecurityInitialState) {
      _currentSecurity = _previousSecurity!;
      _currentSecurity = await _mapCurrentUserSettings(
          settings: _previousSecurity!, currentSettings: _currentSecurity);
      yield currentState.copyWith(
          security: _currentSecurity, isPushToScreen: false);
    }
  }

  /// Check in local storage
  /// After enable/disable Pass Code Setting, passCode in Local Storage will change,
  /// so isPassCode value in this Function, is OLD Pass Code Setting
  /// If currentPassCode == false => Push to Enter Pin Code
  /// If isPassCode == false => Push to Create Pin Code
  String _pushRouteName(SecurityEntity security) {
    final bool isPassCode = _previousSecurity!.isPin!;
    if ((isPassCode && security.isPin! && security.isBio!) ||
        (isPassCode && security.isPin! && !security.isBio!) ||
        (isPassCode && !security.isPin! && !security.isBio!)) {
      return RouteList.enterPIN;
    } else if ((!isPassCode && security.isPin! && security.isBio!) ||
        (!isPassCode && security.isPin! && !security.isBio!)) {
      return RouteList.createDevicePIN;
    }
    return '';
  }

  /// If user enable Biometric Auth, PassCode must enable
  /// If user disable PassCode, Biometric Auth will disable too
  Future<SecurityEntity> _mapCurrentUserSettings(
      {SecurityEntity? settings, SecurityEntity? currentSettings}) async {
    SecurityEntity newSetting;

    if (currentSettings?.isPin == true && settings?.isPin == false) {
      newSetting = SecurityEntity.defaultSecurity();
    } else if (currentSettings?.isBio == false && settings?.isBio == true) {
      newSetting = SecurityEntity(isPin: true, isBio: true);
    } else {
      newSetting = settings!;
    }
    return newSetting;
  }
}
