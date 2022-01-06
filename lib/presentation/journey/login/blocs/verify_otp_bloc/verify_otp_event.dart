part of 'verify_otp_bloc.dart';

abstract class VerifyOtpEvent extends Equatable {
  const VerifyOtpEvent();
}

class InitOTPEvent extends VerifyOtpEvent {
  @override
  List<Object> get props => [];
}

class SendLoadingOTPEvent extends VerifyOtpEvent {
  @override
  List<Object> get props => [];
}

class PressedVerifyOTP extends VerifyOtpEvent {
  final String otpCode;
  final String verificationId;
  final String phoneCode;

  PressedVerifyOTP(
    this.otpCode,
    this.verificationId,
    this.phoneCode,
  );

  @override
  List<Object> get props => [otpCode, verificationId, phoneCode];
}

class SendFailedOTPEvent extends VerifyOtpEvent {
  final Exception? e;

  SendFailedOTPEvent({this.e});

  @override
  List<Object?> get props => [e];
}

class SendVerifyOTPSuccessEvent extends VerifyOtpEvent {
  final UserEntity user;

  SendVerifyOTPSuccessEvent(this.user);

  @override
  List<Object> get props => [user];
}
