part of 'verify_otp_bloc.dart';

abstract class VerifyOtpState extends Equatable {
  const VerifyOtpState();
}

class VerifyOtpInitial extends VerifyOtpState {
  @override
  List<Object> get props => [];
}

class OtpLoading extends VerifyOtpState {
  @override
  List<Object> get props => [];
}

class ResendOTPState extends VerifyOtpState {
  final String verificationId;
  final String phone;

  ResendOTPState(this.verificationId, this.phone);

  @override
  List<Object> get props => [verificationId, phone];
}

class VerifyOTPFailed extends VerifyOtpState {
  final Exception exception;
  final bool isCurrent;

  VerifyOTPFailed({required this.exception, this.isCurrent = true});

  VerifyOTPFailed copyWith({Exception? exception}) {
    return VerifyOTPFailed(
        exception: exception ?? this.exception, isCurrent: !isCurrent);
  }

  @override
  List<Object> get props => [isCurrent, exception];
}

class VerifyOTPSuccess extends VerifyOtpState {
  final bool? isChooseCurrency;
  final bool? isCreateProfile;

  VerifyOTPSuccess.noCreateAction(
      {this.isChooseCurrency = false, this.isCreateProfile = false});

  VerifyOTPSuccess.createUserProfile(
      {this.isChooseCurrency = true, this.isCreateProfile = true});

  VerifyOTPSuccess.createChooseCurrency(
      {this.isChooseCurrency = true, this.isCreateProfile = false});

  @override
  List<Object?> get props => [isCreateProfile, isChooseCurrency];
}
