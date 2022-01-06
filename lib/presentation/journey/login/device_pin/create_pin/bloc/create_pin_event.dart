part of 'create_pin_bloc.dart';

abstract class CreatePinEvent extends Equatable {
  const CreatePinEvent();
}

class BackStepEvent extends CreatePinEvent {
  @override
  List<Object> get props => [];
}

class ConfirmPinCodeEvent extends CreatePinEvent {
  final String pin;
  final SecurityEntity settingsEntity;

  const ConfirmPinCodeEvent(this.pin, this.settingsEntity);

  @override
  List<Object> get props => [pin, settingsEntity];
}

class ChangedPinCode extends CreatePinEvent {
  final String code;

  ChangedPinCode(this.code);

  @override
  List<Object> get props => [code];
}
