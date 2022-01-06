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

part 'create_pin_event.dart';

part 'create_pin_state.dart';

class CreatePinBloc extends Bloc<CreatePinEvent, CreatePinState> {
  final AuthenticationUseCase authenticationUseCase;
  final ProfileUserUseCase profileUserUseCase;
  final AuthenticationBloc authenticationBloc;

  String? _firstPinCode;
  int _countFailed = 0;

  CreatePinBloc(
      {required this.authenticationUseCase,
      required this.profileUserUseCase,
      required this.authenticationBloc})
      : super(FirstStepState(listPinCode: const []));

  @override
  Stream<CreatePinState> mapEventToState(
    CreatePinEvent event,
  ) async* {
    if (event is BackStepEvent) {
      yield* _mapBackStepToState(event);
    } else if (event is ConfirmPinCodeEvent) {
      yield* _mapConfirmCodeToState(event);
    } else if (event is ChangedPinCode) {
      yield* _mapChangedPinCodeToState(event);
    }
  }

  Stream<CreatePinState> _mapBackStepToState(BackStepEvent event) async* {
    _firstPinCode = ''; // clear pinCode when user backed step
    yield FirstStepState(listPinCode: const []);
  }

  /// PIN code will create if user just enable Pass Code
  /// or after user has Biometric Authentication
  Stream<CreatePinState> _mapConfirmCodeToState(
      ConfirmPinCodeEvent event) async* {
    final currentState = state;
    if (currentState is FirstStepState) {
      //  if state is first step
      _firstPinCode = event.pin; // assign pin in first step to pinCode
      yield SecondStepState(listPinCode: const []);
    } else if (currentState is SecondStepState) {
      //  if state is second step
      if (event.pin == _firstPinCode) {
        // match
        yield* _bioAuth(event.settingsEntity);
      } else {
        // not match
        _countFailed++;
        debugPrint(
            'CreatePinBloc - _mapConfirmCodeToState - _countFailed: $_countFailed');
        yield currentState.copyWith(listPinCode: [], isError: true);
      }
    }
  }

  Stream<CreatePinState> _bioAuth(SecurityEntity settingsEntity) async* {
    final bool isBioAuth = settingsEntity.isBio!;
    if (isBioAuth) {
      yield* _scanBio();
    } else {
      // save pin code and settings
      await _createPIN(
          SecurityEntity(pinCode: _firstPinCode, isPin: true, isBio: true));
      yield ConfirmSuccessState(routeName: RouteList.security);
    }
  }

  Stream<CreatePinState> _scanBio() async* {
    final bool authenticated = await authenticationUseCase.authenticate();
    if (authenticated) {
      await _createPIN(
          SecurityEntity(pinCode: _firstPinCode, isPin: true, isBio: true));
    } else {
      await resetSettings();
    }
    yield ConfirmSuccessState(routeName: RouteList.security);
  }

  Future<void> _createPIN(SecurityEntity security) async {
    // await authenticationUseCase.createPin(_firstPinCode);
    final user = authenticationBloc.userEntity;
    user.update(
        setting: SettingEntity(
            notification: user.setting?.notification, security: security));
    await profileUserUseCase.updateProfile(user);
    authenticationBloc.userEntity = user;
  }

  /// If user cancel Bio authentication, old setting going to reset
  /// Because this is CREATE PIN CODE, so old passCode is always false
  Future<void> resetSettings() async {
    final user = authenticationBloc.userEntity;
    user.update(
        setting: SettingEntity(
            notification: user.setting?.notification,
            security: SecurityEntity.defaultSecurity()));
    await profileUserUseCase.updateProfile(user);
  }

  Stream<CreatePinState> _mapChangedPinCodeToState(
      ChangedPinCode event) async* {
    final currentState = state;
    if (currentState is FirstStepState) {
      yield currentState.copyWith(listPinCode: currentState.listPinCode);
    } else if (currentState is SecondStepState) {
      yield currentState.copyWith(listPinCode: currentState.listPinCode);
    }
  }
}
