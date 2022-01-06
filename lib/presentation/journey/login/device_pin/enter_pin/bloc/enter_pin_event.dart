part of 'enter_pin_bloc.dart';

abstract class EnterPinEvent extends Equatable {
  const EnterPinEvent();
}

class EnterPinInitialEvent extends EnterPinEvent {
  final String? previousRoute;

  EnterPinInitialEvent({this.previousRoute});

  @override
  List<Object?> get props => [previousRoute];
}

class ConfirmPinCodeEvent extends EnterPinEvent {
  final String? pin;
  final bool? isDeletePinCode;
  final SecurityEntity? settingsEntity;

  const ConfirmPinCodeEvent(
      {this.pin, this.isDeletePinCode, this.settingsEntity});

  @override
  List<Object?> get props => [pin, isDeletePinCode, settingsEntity];
}

class ChangedPinCode extends EnterPinEvent {
  final String code;

  ChangedPinCode(this.code);

  @override
  List<Object> get props => [code];
}

class ShowScanBioAuth extends EnterPinEvent {
  @override
  List<Object> get props => [];
}
