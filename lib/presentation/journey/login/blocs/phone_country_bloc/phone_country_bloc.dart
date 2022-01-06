import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spendy_re_work/domain/usecases/country_phone_code_usecase.dart';

part 'phone_country_event.dart';

part 'phone_country_state.dart';

class PhoneCountryBloc extends Bloc<PhoneCountryEvent, PhoneCountryState> {
  final CountryPhoneCodeUseCase phoneCodeUseCase;

  PhoneCountryBloc(this.phoneCodeUseCase) : super(PhoneCountryInitial());

  @override
  Stream<PhoneCountryState> mapEventToState(
    PhoneCountryEvent event,
  ) async* {
    if (event is GetDefaultPhoneCode) {
      yield* _getDefaultPhoneCodeToMap();
    } else if (event is SelectPhoneCountry) {
      yield* _mapSelectPhoneCountryToState(event);
    }
  }

  Stream<PhoneCountryState> _getDefaultPhoneCodeToMap() async* {
    try {
      final defaultCode = await phoneCodeUseCase.getDefaultPhoneCode();
      yield PhoneCountriesLoaded(defaultCode: defaultCode);
    } catch (e) {
      yield PhoneCountryFailed();
    }
  }

  Stream<PhoneCountryState> _mapSelectPhoneCountryToState(
      SelectPhoneCountry event) async* {
    final currentState = state;
    if (currentState is PhoneCountriesLoaded) {
      // todo: save default code to local storage
      await phoneCodeUseCase.saveDefaultPhoneCode(event.phoneCode);
      yield currentState.copyWith(event.phoneCode);
    }
  }
}
