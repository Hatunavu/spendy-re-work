import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:spendy_re_work/common/extensions/string_extensions.dart';
import 'package:spendy_re_work/common/utils/internet_util.dart';
import 'package:spendy_re_work/domain/usecases/authentication_usecase.dart';
import 'package:spendy_re_work/presentation/journey/login/blocs/verify_otp_bloc/verify_otp_bloc.dart';
import 'package:spendy_re_work/presentation/journey/login/login_verify_otp/verify_otp_constants.dart';

part 'login_event.dart';

part 'login_state.dart';

/// @Singleton
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationUseCase authenticationUseCase;
  final VerifyOtpBloc verifyOtpBloc;

  String? _phone;

  String? _verificationId;
  int? _forceResendingToken;
  String? _phoneCode;

  LoginBloc(this.verifyOtpBloc, this.authenticationUseCase)
      : super(LoginInitial());

  void resetBloc() {
    _verificationId = null;
    _forceResendingToken = null;
    _phone = null;
    _phoneCode = '';
  }

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is PressedVerifyPhone) {
      // on press verify phone number
      yield LoginLoading();
      resetBloc();
      _phoneCode = event.phoneCode;
      _phone = event.phone.addPrefixPhoneNumber(event.phoneCode!);
      await _mapPressedVerifyPhoneToState(false, event.phoneCode!);
    } else if (event is ResendOTP) {
      await _mapPressedVerifyPhoneToState(true, _phoneCode!);
    } else if (event is SendVerifyPhoneSuccessEvent) {
      // when verify phone success
      yield* _mapSendVerifyPhoneSuccessToState(event);
    } else if (event is SendFailedPhoneEvent) {
      yield VerifyPhoneFailed(exception: event.e);
    } else if (event is LoginNoInternetEvent) {
      yield LoginNoInternetState();
    }
  }

  Future<void> _mapPressedVerifyPhoneToState(
      bool resend, String phoneCode) async {
    final connectivityResult = await InternetUtil.checkInternetConnection();
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      await authenticationUseCase.verifyPhoneNumber(
          phone: _phone,
          forceResendingToken: _forceResendingToken,
          timeout: const Duration(
              seconds: VerifyOtpConstant.timeOutOTPCodeAutoRetrievalSecond),
          codeSent: (String verificationId, [int? forceResendingToken]) =>
              _codeSentCallback(resend, verificationId, forceResendingToken),
          failed: _failedCallback,
          completed: (credential) => _completedCallback(credential, phoneCode));
    } else {
      add(LoginNoInternetEvent());
    }
  }

  void _codeSentCallback(bool resend, String verificationId,
      [int? forceResendingToken]) {
    // after verify phone is successful
    _forceResendingToken = forceResendingToken;
    _verificationId = verificationId;

    verifyOtpBloc.add(InitOTPEvent());
    if (!resend) {
      add(SendVerifyPhoneSuccessEvent(_verificationId!));
    }
  }

  void _failedCallback(FirebaseAuthException exception) {
    // add event to this bloc
    debugPrint(exception.toString());
    add(SendFailedPhoneEvent(exception));
  }

  Future<void> _completedCallback(
      AuthCredential credential, String phoneCode) async {
    verifyOtpBloc.add(SendLoadingOTPEvent());
    try {
      final user = await authenticationUseCase.signIn(credential, phoneCode);
      if (user != null) {
        verifyOtpBloc.add(SendVerifyOTPSuccessEvent(user));
      } else {
        verifyOtpBloc.add(SendFailedOTPEvent());
      }
    } catch (e) {
      verifyOtpBloc.add(SendFailedOTPEvent());
    }
  }

  Stream<LoginState> _mapSendVerifyPhoneSuccessToState(
      SendVerifyPhoneSuccessEvent event) async* {
    await firstLogin();
    yield VerifyPhoneSuccess(event.verificationId, _phone, _phoneCode);
  }

  Future<void> firstLogin() async {
    final bool firstLogin = await authenticationUseCase.getFirstLogin();
    if (!firstLogin) {
      await authenticationUseCase.saveFirstLogin(true);
      await authenticationUseCase.logOut();
    }
  }
}
