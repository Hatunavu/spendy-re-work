part of 'create_pin_bloc.dart';

abstract class CreatePinState extends Equatable {}

class CreatePinLoadingState extends CreatePinState {
  @override
  List<Object> get props => [];
}

class FirstStepState extends CreatePinState {
  final List<String>? listPinCode;
  final bool isCurrent;

  FirstStepState({this.listPinCode, this.isCurrent = true});

  FirstStepState copyWith({List<String>? listPinCode}) =>
      FirstStepState(listPinCode: listPinCode, isCurrent: !isCurrent);

  @override
  List<Object?> get props => [listPinCode, isCurrent];
}

class SecondStepState extends CreatePinState {
  final List<String>? listPinCode;
  final bool? isError;
  final bool isCurrent;

  SecondStepState(
      {this.listPinCode, this.isError = false, this.isCurrent = true});

  SecondStepState copyWith({List<String>? listPinCode, bool isError = false}) =>
      SecondStepState(
          listPinCode: listPinCode, isError: isError, isCurrent: !isCurrent);

  @override
  List<Object?> get props => [listPinCode, isCurrent, isError];
}

class ConfirmSuccessState extends CreatePinState {
  final String routeName;

  ConfirmSuccessState({required this.routeName});
  @override
  List<Object> get props => [];
}
