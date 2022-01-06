part of 'validator_bloc.dart';

abstract class ValidatorEvent extends Equatable {
  const ValidatorEvent();
}

class InitValidatorEvent extends ValidatorEvent {
  @override
  List<Object> get props => [];
}

class SendValidate extends ValidatorEvent {
  final String data;
  final bool isButtonOnPressed;
  final TypeValidator typeValidator;

  SendValidate(
      {required this.data,
      required this.typeValidator,
      this.isButtonOnPressed = false});

  @override
  List<Object> get props => [data, typeValidator, isButtonOnPressed];
}
