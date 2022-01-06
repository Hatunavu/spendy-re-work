part of 'otp_box_bloc.dart';

abstract class OtpBoxState extends Equatable {
  const OtpBoxState();
}

class OtpBoxInitial extends OtpBoxState {
  @override
  List<Object> get props => [];
}

class OtpBoxVerifyFailed extends OtpBoxState {
  @override
  List<Object> get props => [];
}
