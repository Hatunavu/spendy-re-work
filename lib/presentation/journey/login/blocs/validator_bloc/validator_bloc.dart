import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spendy_re_work/common/extensions/string_validator_extensions.dart';
import 'package:spendy_re_work/common/utils/validator_utils.dart';

part 'validator_event.dart';

part 'validator_state.dart';

class ValidatorBloc extends Bloc<ValidatorEvent, ValidatorState> {
  ValidatorBloc() : super(ValidatorInitial());

  @override
  Stream<ValidatorState> mapEventToState(
    ValidatorEvent event,
  ) async* {
    if (event is InitValidatorEvent) {
      yield ValidatorInitial();
    } else if (event is SendValidate) {
      yield* _mapSendValidateToState(event);
    }
  }

  Stream<ValidatorState> _mapSendValidateToState(SendValidate event) async* {
    bool isValid = false;
    final typeValidator = event.typeValidator;
    final data = event.data;

    switch (typeValidator) {
      case TypeValidator.empty:
        isValid = data.isNotNullAndEmpty;
        break;
      case TypeValidator.phone:
        isValid = data.isPhoneNumber;
        break;
      case TypeValidator.password:
        isValid = data.isPassword;
        break;
      case TypeValidator.email:
        isValid = data.isEmail;
        break;
    }
    if (isValid) {
      yield ValidState(data: data);
    } else {
      yield InvalidState(
          data: data, isButtonOnPressed: event.isButtonOnPressed);
    }
  }
}
