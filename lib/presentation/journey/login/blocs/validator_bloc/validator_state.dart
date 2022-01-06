part of 'validator_bloc.dart';

abstract class ValidatorState extends Equatable {
  final String? data;
  final bool? isButtonOnPressed;

  const ValidatorState({this.data, this.isButtonOnPressed = false});

  @override
  List<Object?> get props => [data, isButtonOnPressed];
}

class ValidatorInitial extends ValidatorState {}

class InvalidState extends ValidatorState {
  InvalidState({String? data, bool? isButtonOnPressed})
      : super(data: data, isButtonOnPressed: isButtonOnPressed);
}

class ValidState extends ValidatorState {
  ValidState({String? data, bool? isButtonOnPressed})
      : super(data: data, isButtonOnPressed: isButtonOnPressed);
}
