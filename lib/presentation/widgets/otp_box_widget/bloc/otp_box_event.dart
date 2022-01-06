part of 'otp_box_bloc.dart';

abstract class OtpBoxEvent extends Equatable {
  const OtpBoxEvent();
}

class OtpVerifyFailedEvent extends OtpBoxEvent {
  @override
  List<Object> get props => [];
}
//
//class OtpVerifyFailedEvent extends OtpBoxEvent{
//  @override
//  List<Object> get props => [];
//}
