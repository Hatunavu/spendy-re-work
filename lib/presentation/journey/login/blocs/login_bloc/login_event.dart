part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {}

class ResendOTP extends LoginEvent {
  @override
  List<Object> get props => [];
}

class PressedVerifyPhone extends LoginEvent {
  final String phone;
  final String? phoneCode;

  PressedVerifyPhone(this.phone, {this.phoneCode});

  @override
  List<Object> get props => [
        phone,
      ];
}

class SendFailedPhoneEvent extends LoginEvent {
  final Exception e;

  SendFailedPhoneEvent(this.e);

  @override
  List<Object> get props => [e];
}

class SendVerifyPhoneSuccessEvent extends LoginEvent {
  final String verificationId;
  final int? forceResendingToken;

  SendVerifyPhoneSuccessEvent(this.verificationId, [this.forceResendingToken]);

  @override
  List<Object?> get props => [verificationId, forceResendingToken];
}

class LoginNoInternetEvent extends LoginEvent {
  @override
  List<Object> get props => [];
}
