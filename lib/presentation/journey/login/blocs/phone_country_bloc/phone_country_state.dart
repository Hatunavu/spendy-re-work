part of 'phone_country_bloc.dart';

abstract class PhoneCountryState extends Equatable {
  const PhoneCountryState();
}

class PhoneCountryInitial extends PhoneCountryState {
  @override
  List<Object> get props => [];
}

class PhoneCountryFailed extends PhoneCountryState {
  @override
  List<Object> get props => [];
}

class PhoneCountriesLoaded extends PhoneCountryState {
  final String defaultCode;

  PhoneCountriesLoaded({required this.defaultCode});

  PhoneCountriesLoaded copyWith(String defaultCode) {
    return PhoneCountriesLoaded(defaultCode: defaultCode);
  }

  @override
  List<Object> get props => [defaultCode];
}
