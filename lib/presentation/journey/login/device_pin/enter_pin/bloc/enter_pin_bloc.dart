import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/domain/entities/user/security_entity.dart';
import 'package:spendy_re_work/domain/entities/user/setting_entity.dart';
import 'package:spendy_re_work/domain/usecases/authentication_usecase.dart';
import 'package:spendy_re_work/domain/usecases/profile_user_usecase.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import '../enter_pin_constants.dart';

part 'enter_pin_event.dart';

part 'enter_pin_state.dart';

class EnterPinBloc extends Bloc<EnterPinEvent, EnterPinState> {
  final AuthenticationUseCase authenticationUseCase;
  final ProfileUserUseCase profileUserUseCase;
  final AuthenticationBloc authenticationBloc;

  int _limitTryTimes = EnterPINConstants.limitTryTimes;
  String _previousRoute = '';
  bool _isEnableBioAuth = false;
  SecurityEntity _security = SecurityEntity.defaultSecurity();

  EnterPinBloc(
      {required this.authenticationUseCase,
      required this.authenticationBloc,
      required this.profileUserUseCase})
      : super(ConfirmState(listPinCode: const []));

  @override
  Stream<EnterPinState> mapEventToState(
    EnterPinEvent event,
  ) async* {
    if (event is EnterPinInitialEvent) {
      yield* _mapEnterPinInitialEventToState(event);
    }
    if (event is ConfirmPinCodeEvent) {
      yield* _mapConfirmCodeToState(event);
    } else if (event is ChangedPinCode) {
      yield* _mapChangedPinCodeToState(event);
    }
  }

  Stream<EnterPinState> _mapEnterPinInitialEventToState(
      EnterPinInitialEvent event) async* {
    _previousRoute = event.previousRoute ?? '';
    _security = authenticationBloc.userEntity.setting!.security!;
    _isEnableBioAuth = _security.isBio!;
    if (_isEnableBioAuth && _previousRoute != RouteList.security) {
      // if bio has been enabled and previous route is not security
      yield* _bioAuth();
    }
    yield ConfirmState(listPinCode: const []);
  }

  Stream<EnterPinState> _mapConfirmCodeToState(
      ConfirmPinCodeEvent event) async* {
    final currentState = state;

    if (currentState is ConfirmState) {
      // # 1: Check enter pin code is true or not
      final isMatch = authPin(event.pin!);
      if (isMatch) {
        // #2: Pin code is true
        if (_previousRoute == RouteList.security) {
          // #2.1: User disable passCode
          if (!event.settingsEntity!.isPin!) {
            // clean PIN code
            event.settingsEntity?.pinCode = '';
          }
          // 2.2: Update pin value for new security settings
          event.settingsEntity?.pinCode = event.pin;
          // #2.2: Checking user enable or disable bioAuth
          if (event.settingsEntity!.isBio!) {
            yield* _bioAuth(
                isEnableBioAuth: true, newSettings: event.settingsEntity!);
          } else {
            // save settings when change in secure settings
            final user = authenticationBloc.userEntity;
            user.update(
                setting: SettingEntity(
                    notification: user.setting?.notification,
                    security: event.settingsEntity));
            await profileUserUseCase.updateProfile(user);
          }
        }
        yield* _confirmSuccessState();
      } else {
        // not match
        _limitTryTimes--;
        debugPrint('>>> _limitTryTimes: $_limitTryTimes');
        if (_limitTryTimes == 0) {
          // over try times
          _handlingOverTryTimes();
        } else {
          yield currentState.copyWith(
              listPinCode: [], isError: true, countFailed: _limitTryTimes);
        }
      }
    }
  }

  /// 2 cases:
  /// - Case 1: Config Enable Bio Auth
  /// - Case 2: Authentication by Bio Auth
  Stream<EnterPinState> _bioAuth(
      {bool isEnableBioAuth = false, SecurityEntity? newSettings}) async* {
    final currentSettings = authenticationBloc.userEntity.setting?.security;

    final bool isBioAuth = currentSettings!.isBio! || newSettings!.isBio!;
    if (isBioAuth) {
      yield* _scanBio(
          isEnableBioAuth: isEnableBioAuth, newSettings: newSettings!);
    } else {
      yield* _confirmSuccessState();
    }
  }

  Stream<EnterPinState> _scanBio(
      {bool isEnableBioAuth = false, SecurityEntity? newSettings}) async* {
    await Future.delayed(
        const Duration(milliseconds: 500), () {}); // wait 500 ms
    final bool authenticated =
        await authenticationUseCase.authenticate(); // authen bio
    debugPrint('CreatePinBloc - scanBloc - authenticated: $authenticated');
    if (!authenticated) {
      if (isEnableBioAuth) {
        // reset auth settings
        await resetSettings();
        yield* _confirmSuccessState();
      } else {
        yield ConfirmState(listPinCode: const []);
      }
    } else {
      if (newSettings != null) {
        // save settings when change in secure settings
        final user = authenticationBloc.userEntity;
        user.update(
            setting: SettingEntity(
                notification: user.setting?.notification,
                security: newSettings));
      }
      yield* _confirmSuccessState();
    }
  }

  /// If user cancel Bio authentication, old setting going to reset
  /// Because this is ENTER PIN CODE (Pass code is always ready),
  /// So old passCode is always true
  Future<void> resetSettings() async {
    final user = authenticationBloc.userEntity;
    user.update(
        setting: SettingEntity(
            notification: user.setting?.notification,
            security: SecurityEntity.defaultSecurity()));
    await profileUserUseCase.updateProfile(user);
  }

  Stream<EnterPinState> _mapChangedPinCodeToState(ChangedPinCode event) async* {
    final currentState = state;
    if (currentState is ConfirmState) {
      yield currentState.copyWith(listPinCode: currentState.listPinCode);
    }
  }

  Stream<EnterPinState> _confirmSuccessState() async* {
    await authenticationBloc.savePinAuthState(false);
    yield ConfirmSuccessState();
  }

  void _handlingOverTryTimes() {
    authenticationBloc.add(LoggedOut());
  }

  bool authPin(String input) {
    return _security.pinCode == input;
  }
}
