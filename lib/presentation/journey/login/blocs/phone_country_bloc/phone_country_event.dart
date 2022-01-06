part of 'phone_country_bloc.dart';

abstract class PhoneCountryEvent extends Equatable {
  const PhoneCountryEvent();
}

class GetDefaultPhoneCode extends PhoneCountryEvent {
  @override
  List<Object> get props => [];
}

class SelectPhoneCountry extends PhoneCountryEvent {
  final String phoneCode;

  SelectPhoneCountry(this.phoneCode);

  @override
  List<Object> get props => [phoneCode];
}
