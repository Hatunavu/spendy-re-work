part of 'enter_pin_bloc.dart';

abstract class EnterPinState extends Equatable {
  const EnterPinState();
}

class ConfirmState extends EnterPinState {
  final List<String>? listPinCode;
  final bool isError;
  final int limitTimes;
  final bool isCurrent;

  ConfirmState(
      {this.listPinCode,
      this.limitTimes = 0,
      this.isError = false,
      this.isCurrent = true});

  ConfirmState copyWith(
          {List<String>? listPinCode,
          bool isError = false,
          int countFailed = 0}) =>
      ConfirmState(
          listPinCode: listPinCode,
          isError: isError,
          limitTimes: countFailed,
          isCurrent: !isCurrent);

  @override
  List<Object?> get props => [listPinCode, isCurrent, isError, limitTimes];
}

class ConfirmSuccessState extends EnterPinState {
  @override
  List<Object> get props => [];
}
