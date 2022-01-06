import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spendy_re_work/common/constants/shared_preference_keys_constants.dart';
import 'package:spendy_re_work/common/local_preferences/local_preferences.dart';
import 'package:spendy_re_work/domain/entities/user/user_entity.dart';
import 'package:spendy_re_work/domain/usecases/app_default_usecase.dart';
import 'package:spendy_re_work/domain/usecases/authentication_usecase.dart';
import 'package:spendy_re_work/domain/usecases/group_usecase.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/common/extensions/string_validator_extensions.dart';

part 'verify_otp_event.dart';

part 'verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final AuthenticationUseCase authenticationUseCase;
  final AuthenticationBloc authenticationBloc;
  final LocalPreferences localPreferences;
  final GroupUseCase groupUseCase;
  final AppDefaultUsecase appDefaultUsecase;
  VerifyOtpBloc(this.authenticationBloc, this.authenticationUseCase, this.localPreferences,
      this.groupUseCase, this.appDefaultUsecase)
      : super(VerifyOtpInitial());

  @override
  Stream<VerifyOtpState> mapEventToState(
    VerifyOtpEvent event,
  ) async* {
    if (event is InitOTPEvent) {
      yield VerifyOtpInitial();
    } else if (event is SendLoadingOTPEvent) {
      yield OtpLoading();
    } else if (event is PressedVerifyOTP) {
      // on press verify otp code
      yield* _mapPressedVerifyOTPToState(event);
    } else if (event is SendVerifyOTPSuccessEvent) {
      // when verify otp success
      yield* _mapVerifyOTPSuccessToState(event.user);
    } else if (event is SendFailedOTPEvent) {
      final currentState = state;
      if (currentState is VerifyOTPFailed) {
        yield currentState.copyWith();
      } else {
        yield VerifyOTPFailed(
          exception: event.e ?? FirebaseAuthException(message: 'OTP is not correct', code: '408'),
        );
      }
    }
  }

  Stream<VerifyOtpState> _mapPressedVerifyOTPToState(PressedVerifyOTP event) async* {
    // when on pressed verify otp
    yield OtpLoading();
    try {
      final user = await authenticationUseCase.verifyOTP(
          event.verificationId, event.otpCode, event.phoneCode);
      if (user != null) {
        yield* _mapVerifyOTPSuccessToState(user);
      } else {
        yield VerifyOTPFailed(exception: Exception('user is empty'));
      }
    } catch (e) {
      yield VerifyOTPFailed(exception: e as Exception);
    }
  }

  Stream<VerifyOtpState> _mapVerifyOTPSuccessToState(UserEntity userEntity) async* {
    authenticationBloc.userEntity = userEntity;
    await localPreferences.set(SharedPreferenceKeys.userId, userEntity.uid);
    if (userEntity.fullName?.isNullOrEmpty ?? true) {
      yield VerifyOTPSuccess.createUserProfile();
    } else {
      if (userEntity.isoCode?.isNullOrEmpty ?? true) {
        yield VerifyOTPSuccess.createChooseCurrency();
      } else {
        authenticationBloc.add(LoggedIn(userEntity));
        await groupUseCase.getDataGroup(userEntity.uid ?? '',
            defaultGroup: appDefaultUsecase.getGroupRemoteConfig());
        yield VerifyOTPSuccess.noCreateAction();
      }
    }
  }
}
